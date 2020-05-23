#include "FileHashIterator.hpp"
#include <QFile>
#include <QCryptographicHash>

FileHashIterator::FileHashIterator(const QString &filePath)
{
    _file = new QFile(filePath);
    _error = !_file->open(QIODevice::ReadOnly);
}

FileHashIterator::~FileHashIterator()
{
    _file->close();
    delete _file;
}

void FileHashIterator::restart()
{
    _hashIndex = 0;
}

QByteArray FileHashIterator::getNextHash()
{
    if (_error) {
        return QByteArray();
    }

    if (_hashIndex < _hashes.size()) {
        return _hashes.value(_hashIndex++);
    }

    if (_eof) {
        return QByteArray();
    }

    auto data = _file->read(HashBlockSize);
    if (data.size() < HashBlockSize) {
        _eof = true;
        _file->close();
    }

    if (data.isEmpty()) {
        return QByteArray();
    }

    auto hash = QCryptographicHash::hash(data, QCryptographicHash::Md5);
    _hashes << hash;
    _hashIndex++;

    return hash;
}

bool FileHashIterator::error() const
{
    return _error;
}
