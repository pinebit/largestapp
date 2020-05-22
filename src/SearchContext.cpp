#include "SearchContext.hpp"
#include "SearchConfig.hpp"
#include "ResultsListModel.hpp"
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
