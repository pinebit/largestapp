#include "StoragesListModel.hpp"

namespace {
const char *NameRoleName = "name";
const char *DisplayNameRoleName = "displayName";
const char *RootPathRoleName = "rootPath";
const char *SpaceAvailableRoleName = "spaceAvailable";
}

StoragesListModel::StoragesListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    refresh();
}

int StoragesListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return _volumes.size();
}

QVariant StoragesListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    const auto volume = _volumes[index.row()];
    switch (static_cast<Roles>(role)) {
    case NameRole:
        return volume.name();
    case DisplayNameRole:
        return volume.displayName();
    case RootPathRole:
        return volume.rootPath();
    case SpaceAvailableRole:
        return volume.bytesAvailable() / (qreal)volume.bytesTotal();
    }

    return QVariant();
}

QHash<int, QByteArray> StoragesListModel::roleNames() const
{
    static QHash<int, QByteArray> roles = {
        { NameRole, NameRoleName },
        { DisplayNameRole, DisplayNameRoleName },
        { RootPathRole, RootPathRoleName },
        { SpaceAvailableRole, SpaceAvailableRoleName }
    };

    return roles;
}

void StoragesListModel::refresh()
{
    beginResetModel();
    _volumes = QStorageInfo::mountedVolumes();
    endResetModel();
}
