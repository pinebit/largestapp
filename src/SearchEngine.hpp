#ifndef SEARCHENGINE_HPP
#define SEARCHENGINE_HPP

#include <QObject>
#include <QHash>
#include <src/SearchContext.hpp>
#include <src/SearchConfig.hpp>

class SearchEngine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(SearchConfig* config READ config CONSTANT)

public:
    explicit SearchEngine(QObject *parent = nullptr);

    Q_INVOKABLE SearchContext* getSearchContext(const QString &rootPath);

    SearchConfig* config() const;

private:
    QHash<QString, SearchContext*> _context;
    SearchConfig *_config;
};

Q_DECLARE_METATYPE(SearchEngine*);

#endif // SEARCHENGINE_HPP
