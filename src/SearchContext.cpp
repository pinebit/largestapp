#include "SearchContext.hpp"
#include "SearchConfig.hpp"
#include "ResultsListModel.hpp"
#include <QDebug>
#include <QtConcurrent>
#include <QDirIterator>
#include <QLocale>
#include <QCryptographicHash>
#include <algorithm>

namespace {
const int HashBlockSize = 1024 * 256;

bool compareFileSizes(const QFileInfo &info1, const QFileInfo &info2)
{
    return info2.size() < info1.size();
}

QList<QByteArray> calcHashChain(const QString &path, std::atomic<bool> *running) {
    QList<QByteArray> chain;
    QFile file(path);

    if (file.open(QIODevice::ReadOnly)) {
        bool eof = false;
        while (!eof && *running) {
            auto data = file.read(HashBlockSize);
            if (!data.isEmpty()) {
                chain << QCryptographicHash::hash(data, QCryptographicHash::Md5);
            }
            eof = data.size() < HashBlockSize;
        }
        file.close();
    }

    return chain;
}

bool compareFileToHashChain(const QList<QByteArray> &testChain, const QString &path, std::atomic<bool> *running) {
    QFile file(path);

    if (file.open(QIODevice::ReadOnly)) {
        int index = 0;
        bool eof = false;
        while (!eof && *running) {
            auto data = file.read(HashBlockSize);
            if (!data.isEmpty()) {
                auto hash = QCryptographicHash::hash(data, QCryptographicHash::Md5);
                if (hash != testChain[index]) {
                    return false;
                }
                index++;
            }
            eof = data.size() < HashBlockSize;
        }
        file.close();
    } else {
        return false;
    }

    return true;
}
}

SearchContext::SearchContext(const QString &rootPath,
                             SearchConfig *config,
                             QObject *parent)
    : QObject(parent)
    , _rootPath(rootPath)
    , _config(config)
    , _listModel(new ResultsListModel(this, this))
{
    qRegisterMetaType<SearchState>("SearchState");
    qRegisterMetaType<ResultsListModel*>("ResultsListModel*");
}

QString SearchContext::rootPath() const
{
    return _rootPath;
}

bool SearchContext::isSearching() const
{
    return _state == SearchState::Searching;
}

bool SearchContext::isCompleted() const
{
    return _state == SearchState::Completed;
}

QList<QFileInfo> SearchContext::files() const
{
    return _files;
}

ResultsListModel *SearchContext::resultsListModel() const
{
    return _listModel;
}

bool SearchContext::deleteFile(const QString &path)
{
    QFile file(path);
    if (!file.setPermissions(QFileDevice::WriteOther) || !file.remove()) {
        return false;
    }

    _files.removeOne(QFileInfo(path));
    emit updated();

    return true;
}

void SearchContext::findDuplicates(const QString &path)
{
    if (_findingDuplicates) {
        qWarning() << "Already finding a duplicate!";
        return;
    }

    _findingDuplicates = true;

    QtConcurrent::run([this, fileList = _files, path]{
        const auto testSize = QFileInfo(path).size();
        QList<int> candidates;

        emit statusUpdated(tr("Locating potential candidates..."));

        int testIndex = 0;
        int index = 0;
        for (const auto &info : fileList) {
            if (info.filePath() == path) {
                testIndex = index;
            }
            if (info.filePath() != path &&
                info.isReadable() &&
                info.size() == testSize) {
                candidates << index;
            }
            index++;
        }

        QList<QFileInfo> newList;
        newList << _files[testIndex];

        if (!candidates.isEmpty() && _findingDuplicates) {
            emit statusUpdated(tr("Calculating test file hash..."));
            const auto testChain = calcHashChain(path, &_findingDuplicates);

            for (int ci : candidates) {
                if (!_findingDuplicates) {
                    break;
                }
                const auto path = fileList[ci].filePath();
                emit statusUpdated(tr("Checking candidate: %1").arg(path));
                bool duplicate = compareFileToHashChain(testChain, path, &_findingDuplicates);
                if (duplicate) {
                    newList << fileList[ci];
                }
            }
        }

        if (newList.size() > 1 && _findingDuplicates) {
            _files = newList;
            emit updated();
        }

        emit duplicatesFound(newList.size() - 1);

        _findingDuplicates = false;
    });
}

void SearchContext::cancelFindingDuplicates()
{
    _findingDuplicates = false;
}

void SearchContext::restart()
{
    if (_state == SearchState::Searching) {
        qWarning() << "already searching in" << _rootPath;
        return;
    }

    _state = SearchState::Searching;

    emit updated();

    QtConcurrent::run([this]{
        _files.clear();
        QDirIterator it(_rootPath, QDir::Files, QDirIterator::Subdirectories);

        while (it.hasNext() && _state == SearchState::Searching) {
            auto info = it.fileInfo();
            emit statusUpdated(info.dir().path());
            if (_config->ignoreHidden() && info.isHidden()) {
                it.next();
                continue;
            }
            if (info.size() > _config->minFileSize()) {
                _files << info;
            }
            it.next();
        }

        emit statusUpdated(tr("Sorting the files..."));

        std::sort(_files.begin(), _files.end(), compareFileSizes);

        if (_files.size() > _config->maxTopFiles()) {
            _files = _files.mid(0, _config->maxTopFiles());
        }

        _state = SearchState::Completed;

        emit updated();
    });
}

void SearchContext::stop()
{
    if (_state != SearchState::Searching) {
        qWarning() << "not searching in" << _rootPath;
        return;
    }

    _state = SearchState::Completed;

    emit updated();
}
