#include "DuplicatesFinder.hpp"
#include "SearchContext.hpp"
#include "CompareFiles.hpp"
#include <QDebug>
#include <QtConcurrent>

DuplicatesFinder::DuplicatesFinder(QObject *parent)
    : QObject(parent)
{
    qRegisterMetaType<SearchContext*>("SearchContext*");
}

void DuplicatesFinder::find(SearchContext *context, const QString &filePath)
{
    if (_busy) {
        qWarning() << "Already searching for duplicates!";
        return;
    }

    _busy = true;
    auto files = context->files();

    QtConcurrent::run([this, files, filePath]{
        QList<QString> duplicates;
        const auto testFileSize = QFileInfo(filePath).size();

        for (const auto file : files) {
            if (!_busy) {
                break;
            }

            const auto candidatePath = file.filePath();

            if (file.size() != testFileSize || candidatePath == filePath) {
                continue;
            }

            emit testingCandidate(candidatePath);

            if (CompareFiles::compare(filePath, candidatePath, _busy)) {
                duplicates << candidatePath;
            }
        }

        if (_busy) {
            _busy = false;

            emit found(duplicates);
        }
    });
}

void DuplicatesFinder::cancel()
{
    _busy = false;
}
