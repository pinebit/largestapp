#include "SearchEngine.hpp"
#include <QDebug>

SearchEngine::SearchEngine(QObject *parent)
    : QObject(parent)
{
    qRegisterMetaType<SearchContext*>("SearchContext*");
}

SearchContext *SearchEngine::getSearchContext(const QString &rootPath)
{
    if (!_context.contains(rootPath)) {
        _context.insert(rootPath, new SearchContext(rootPath, this));
    }

    return _context[rootPath];
}
