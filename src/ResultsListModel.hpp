#ifndef RESULTSLISTMODEL_HPP
#define RESULTSLISTMODEL_HPP

#include <QAbstractListModel>
#include <QFileInfo>

class SearchContext;

class ResultsListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit ResultsListModel(SearchContext *context, QObject *parent = nullptr);

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void setGroupByFolders(bool on);

private slots:
    void refreshData();

private:
    enum Roles {
        FilePathRole = Qt::UserRole + 1,
        FileDirectoryRole,
        FileSizeRole
    };

    QList<QFileInfo> _files;
    SearchContext *_context;
    bool _groupByFolders { false };
};

Q_DECLARE_METATYPE(ResultsListModel*);

#endif // RESULTSLISTMODEL_HPP
