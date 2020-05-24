#ifndef DUPLICATESFINDER_HPP
#define DUPLICATESFINDER_HPP

#include <QObject>
#include <QByteArray>
#include <atomic>

class SearchContext;

class DuplicatesFinder : public QObject
{
    Q_OBJECT

public:
    explicit DuplicatesFinder(QObject *parent = nullptr);

public slots:
    void find(SearchContext *context, const QString &filePath);
    void cancel();

signals:
    void found(const QList<QString> &duplicates);
    void testingCandidate(const QString &filePath);

private:
    std::atomic<bool> _busy { false };
};

Q_DECLARE_METATYPE(DuplicatesFinder*);

#endif // DUPLICATESFINDER_HPP
