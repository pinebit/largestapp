#ifndef FILEHASHITERATOR_HPP
#define FILEHASHITERATOR_HPP

#include <QList>
#include <QByteArray>

class QFile;

class FileHashIterator
{
public:
    explicit FileHashIterator(const QString &filePath);
    virtual ~FileHashIterator();

    void restart();
    QByteArray getNextHash();
    bool error() const;

private:
    const int HashBlockSize = 1024 * 256;

    QList<QByteArray> _hashes;
    QFile *_file;
    int _hashIndex { 0 };
    bool _error { false };
    bool _eof { false };
};

#endif // FILEHASHITERATOR_HPP
