#ifndef SEARCHCONFIG_HPP
#define SEARCHCONFIG_HPP

#include <QObject>

class SearchConfig : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int maxTopFiles MEMBER _maxTopFiles NOTIFY maxTopFilesChanged)
    Q_PROPERTY(int minFileSize MEMBER _minFileSize NOTIFY minFileSizeChanged)
    Q_PROPERTY(bool ignoreHidden MEMBER _ignoreHidden NOTIFY ignoreHiddenChanged)

public:
    explicit SearchConfig(QObject *parent = nullptr);

    int maxTopFiles() const;
    int minFileSize() const;
    bool ignoreHidden() const;

signals:
    void maxTopFilesChanged();
    void minFileSizeChanged();
    void ignoreHiddenChanged();

private:
    int _maxTopFiles { 100 };
    int _minFileSize { 1024 };
    bool _ignoreHidden { true };
};

Q_DECLARE_METATYPE(SearchConfig*);

#endif // SEARCHCONFIG_HPP
