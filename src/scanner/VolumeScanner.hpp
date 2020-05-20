#ifndef VOLUMESCANNER_HPP
#define VOLUMESCANNER_HPP

#include <QObject>
#include <QList>

class VolumeScanner : public QObject
{
    Q_OBJECT

public:
    explicit VolumeScanner(QObject *parent = nullptr);

    QStringList files() const;

public slots:
    void start(const QString &rootPath);
    void stop();

private:
    QStringList _files;
};

#endif // VOLUMESCANNER_HPP
