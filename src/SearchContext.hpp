#ifndef SEARCHCONTEXT_HPP
#define SEARCHCONTEXT_HPP

#include <QObject>
#include <src/SearchState.hpp>

class SearchConfig;

class SearchContext : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString rootPath READ rootPath CONSTANT)
    Q_PROPERTY(QStringList files READ files NOTIFY updated)
    Q_PROPERTY(bool isSearching READ isSearching NOTIFY updated)
    Q_PROPERTY(bool isCompleted READ isCompleted NOTIFY updated)

public:
    explicit SearchContext(const QString &rootPath,
                           SearchConfig *config,
                           QObject *parent = nullptr);

    QString rootPath() const;
    QStringList files() const;
    bool isSearching() const;
    bool isCompleted() const;

    Q_INVOKABLE QString getFileSize(const QString &path) const;
    Q_INVOKABLE QString getFileDirectory(const QString &path) const;
    Q_INVOKABLE bool deleteFile(const QString &path);

public slots:
    void restart();
    void stop();

signals:
    void updated();
    void statusUpdated(const QString &status);

private:
    QString _rootPath;
    SearchState _state { SearchState::New };
    QStringList _files;
    SearchConfig* _config;
};

Q_DECLARE_METATYPE(SearchContext*);

#endif // SEARCHCONTEXT_HPP
