#include "SearchContext.hpp"
#include "SearchConfig.hpp"
#include <QDebug>
#include <QtConcurrent>
#include <QDirIterator>
#include <QLocale>
#include <algorithm>

namespace {
bool compareFileSizes(const QFileInfo &info1, const QFileInfo &info2)
{
    return info2.size() < info1.size();
}
}

SearchContext::SearchContext(const QString &rootPath,
                             SearchConfig *config,
                             QObject *parent)
    : QObject(parent)
    , _rootPath(rootPath)
    , _config(config)
{
    qRegisterMetaType<SearchState>("SearchState");
}

QString SearchContext::rootPath() const
{
    return _rootPath;
}

QStringList SearchContext::files() const
{
    return _files;
}

bool SearchContext::isSearching() const
{
    return _state == SearchState::Searching;
}

bool SearchContext::isCompleted() const
{
    return _state == SearchState::Completed;
}

QString SearchContext::getFileSize(const QString &path) const
{
    QFileInfo info(path);
    QLocale locale;

    return locale.formattedDataSize(info.size());
}

QString SearchContext::getFileDirectory(const QString &path) const
{
    QFileInfo info(path);
    return info.dir().path();
}

bool SearchContext::deleteFile(const QString &path)
{
    QFile file(path);
    if (!file.setPermissions(QFileDevice::WriteOther) || !file.remove()) {
        return false;
    }

    _files.removeOne(path);
    emit updated();

    return true;
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
        QList<QFileInfo> fileInfoList;

        QDirIterator it(_rootPath, QDir::Files, QDirIterator::Subdirectories);
        while (it.hasNext() && _state == SearchState::Searching) {
            auto info = it.fileInfo();
            emit statusUpdated(info.dir().path());
            if (_config->ignoreHidden() && info.isHidden()) {
                it.next();
                continue;
            }
            if (info.size() > _config->minFileSize()) {
                fileInfoList << info;
            }
            it.next();
        }

        emit statusUpdated(tr("Sorting the files..."));

        std::sort(fileInfoList.begin(), fileInfoList.end(), compareFileSizes);

        if (fileInfoList.size() > _config->maxTopFiles()) {
            fileInfoList = fileInfoList.mid(0, _config->maxTopFiles());
        }

        _files.clear();
        _files.reserve(fileInfoList.size());

        for (const auto &info : fileInfoList) {
            _files << info.filePath();
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
