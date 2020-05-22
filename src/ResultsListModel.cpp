#include "ResultsListModel.hpp"
#include "SearchContext.hpp"
#include <QDir>
#include <QLocale>

namespace {
const char *FilePathRoleName = "filePath";
const char *FileDirectoryRoleName = "fileDir";
const char *FileSizeRoleName = "fileSize";
}

ResultsListModel::ResultsListModel(SearchContext *context, QObject *parent)
    : QAbstractListModel(parent)
    , _context(context)
{
    connect(context, &SearchContext::updated, this, &ResultsListModel::refreshData);
}

int ResultsListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return _files.size();
}

QVariant ResultsListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    const auto fileInfo = _files[index.row()];

    switch (static_cast<Roles>(role)) {
    case FilePathRole:
        return fileInfo.filePath();
    case FileDirectoryRole: {
        return fileInfo.dir().path();
    }
    case FileSizeRole: {
        QLocale locale;
        return locale.formattedDataSize(fileInfo.size());
    }
    }

    return QVariant();
}

QHash<int, QByteArray> ResultsListModel::roleNames() const
{
    static QHash<int, QByteArray> roles = {
        { FilePathRole, FilePathRoleName },
        { FileDirectoryRole, FileDirectoryRoleName },
        { FileSizeRole, FileSizeRoleName }
    };

    return roles;
}

void ResultsListModel::setGroupByFolders(bool on)
{
    if (_groupByFolders != on) {
        _groupByFolders = on;

        refreshData();
    }
}

void ResultsListModel::refreshData()
{
    beginResetModel();

    _files = _context->files();

    if (_groupByFolders) {
        QStringList dirs;
        QHash<QString, QList<int>> map;
        int index = 0;

        for (const auto &info : _files) {
            const auto dir = info.dir().path();
            if (!map.contains(dir)) {
                dirs << dir;
            }
            map[dir] << index;
            index++;
        }

        QList<QFileInfo> newList;
        for (auto dir : dirs) {
            const auto &indices = map.value(dir);
            for (int index : indices) {
                newList << _files[index];
            }
        }        
        _files = newList;
    }

    endResetModel();
}
