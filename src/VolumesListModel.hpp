#ifndef VOLUMESLISTMODEL_HPP
#define VOLUMESLISTMODEL_HPP

#include <QAbstractListModel>
#include <QStorageInfo>

class VolumesListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit VolumesListModel(QObject *parent = nullptr);

    Q_INVOKABLE int getDefaultIndex() const;

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void refresh();

private:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        DisplayNameRole,
        RootPathRole,
        SpaceAvailableRole
    };

    QList<QStorageInfo> _volumes;
};

Q_DECLARE_METATYPE(VolumesListModel*);

#endif // VOLUMESLISTMODEL_HPP
