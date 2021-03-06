#ifndef SEARCHCONTEXT_HPP
#define SEARCHCONTEXT_HPP

#include <QObject>
#include <QFileInfo>
#include <src/SearchState.hpp>
#include <src/ResultsListModel.hpp>

class SearchConfig;

class SearchContext : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString rootPath READ rootPath CONSTANT)
    Q_PROPERTY(bool isSearching READ isSearching NOTIFY updated)
    Q_PROPERTY(bool isCompleted READ isCompleted NOTIFY updated)
    Q_PROPERTY(ResultsListModel* resultsListModel READ resultsListModel CONSTANT)

public:
    explicit SearchContext(const QString &rootPath,
                           SearchConfig *config,
                           QObject *parent = nullptr);

    QString rootPath() const;
    bool isSearching() const;
    bool isCompleted() const;
    QList<QFileInfo> files() const;
    ResultsListModel *resultsListModel() const;

public slots:
    void restart();
    void stop();
    bool deleteFile(const QString &path, bool moveToTrash);
    void openFile(const QString &path);

signals:
    void updated();
    void statusUpdated(const QString &status);

private:
    QString _rootPath;
    SearchState _state { SearchState::New };
    QList<QFileInfo> _files;
    SearchConfig* _config;
    ResultsListModel* _listModel;
};

Q_DECLARE_METATYPE(SearchContext*);

#endif // SEARCHCONTEXT_HPP
