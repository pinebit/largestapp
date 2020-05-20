#include "VolumeScanner.hpp"
#include <QDirIterator>

VolumeScanner::VolumeScanner(QObject *parent)
    : QObject(parent)
{
}

QStringList VolumeScanner::files() const
{
    return _files;
}

void VolumeScanner::start(const QString &rootPath)
{
    _files.clear();

    QDirIterator it(rootPath, QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        const auto info = it.fileInfo();
        if (info.size() == 0) {
            continue;
        }
        _files << it.next();
    }
}

void VolumeScanner::stop()
{
}
