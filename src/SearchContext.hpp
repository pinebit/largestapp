#ifndef SEARCHCONTEXT_HPP
#define SEARCHCONTEXT_HPP

#include <QObject>
#include <QFileInfo>
#include <atomic>
#include <src/SearchState.hpp>

class SearchConfig;
class ResultsListModel;

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
    bool deleteFile(const QString &path);
    void findDuplicates(const QString &path);
    void cancelFindingDuplicates();
    void openFile(const QString &path);

signals:
    void updated();
    void statusUpdated(const QString &status);
    void duplicatesFound(int count);

private:
    QString _rootPath;
    SearchState _state { SearchState::New };
    QList<QFileInfo> _files;
    SearchConfig* _config;
    ResultsListModel* _listModel;
    std::atomic<bool> _findingDuplicates { false };
};

Q_DECLARE_METATYPE(SearchContext*);

#endif // SEARCHCONTEXT_HPP
