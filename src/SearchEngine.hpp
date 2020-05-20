#ifndef SEARCHENGINE_HPP
#define SEARCHENGINE_HPP

#include <QObject>
#include <QHash>
#include <src/SearchContext.hpp>

class SearchEngine : public QObject
{
    Q_OBJECT

public:
    explicit SearchEngine(QObject *parent = nullptr);

    Q_INVOKABLE SearchContext* getSearchContext(const QString &rootPath);

private:
    QHash<QString, SearchContext*> _context;
};

Q_DECLARE_METATYPE(SearchEngine*);

#endif // SEARCHENGINE_HPP
