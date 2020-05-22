#include "SearchEngine.hpp"
#include <QDebug>

SearchEngine::SearchEngine(QObject *parent)
    : QObject(parent)
    , _config(new SearchConfig(this))
{
    qRegisterMetaType<SearchContext*>("SearchContext*");
    qRegisterMetaType<SearchConfig*>("SearchConfig*");
}

SearchContext *SearchEngine::getSearchContext(const QString &rootPath)
{
    if (!_context.contains(rootPath)) {
        _context.insert(rootPath, new SearchContext(rootPath, _config, this));
    }

    return _context[rootPath];
}

SearchConfig *SearchEngine::config() const
{
    return _config;
}

