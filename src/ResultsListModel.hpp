#ifndef RESULTSLISTMODEL_HPP
#define RESULTSLISTMODEL_HPP

#include <QAbstractListModel>

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

private slots:
    void contextUpdated();

private:
    enum Roles {
        FilePathRole = Qt::UserRole + 1,
        FileDirectoryRole,
        FileSizeRole
    };

    QList<QString> _files;
    SearchContext *_context;
};

Q_DECLARE_METATYPE(ResultsListModel*);

#endif // RESULTSLISTMODEL_HPP
