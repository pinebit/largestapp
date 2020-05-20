#include "SearchContext.hpp"
#include <QDebug>

SearchContext::SearchContext(const QString &rootPath, QObject *parent)
    : QObject(parent)
    , _rootPath(rootPath)
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

void SearchContext::restart()
{
    if (_state == SearchState::Searching) {
        qWarning() << "already searching in" << _rootPath;
        return;
    }

    _state = SearchState::Searching;

    emit updated();
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
