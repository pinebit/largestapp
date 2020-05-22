#include "ResultsListModel.hpp"
#include "SearchContext.hpp"
#include <QFileInfo>
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
    connect(context, &SearchContext::updated, this, &ResultsListModel::contextUpdated);
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

    const auto filePath = _files[index.row()];

    switch (static_cast<Roles>(role)) {
    case FilePathRole:
        return filePath;
    case FileDirectoryRole: {
        QFileInfo info(filePath);
        return info.dir().path();
    }
    case FileSizeRole: {
        QFileInfo info(filePath);
        QLocale locale;
        return locale.formattedDataSize(info.size());
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

void ResultsListModel::contextUpdated()
{
    beginResetModel();
    _files = _context->files();
    endResetModel();
}
