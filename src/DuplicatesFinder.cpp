#include "DuplicatesFinder.hpp"
#include "SearchContext.hpp"
#include "FileHashIterator.hpp"
#include <QDebug>
#include <QtConcurrent>
#include <QFileInfo>

DuplicatesFinder::DuplicatesFinder(QObject *parent)
    : QObject(parent)
{
    qRegisterMetaType<SearchContext*>("SearchContext*");
}

void DuplicatesFinder::find(SearchContext *context, const QString &filePath)
{
    if (_busy) {
        qWarning() << "Already finding a duplicate!";
        return;
    }

    _busy = true;
    auto files = context->files();

    QtConcurrent::run([this, files, filePath]{
        const auto testSize = QFileInfo(filePath).size();
        QList<int> candidates;

        for (int i = 0; i < files.size(); ++i) {
            if (files[i].filePath() != filePath &&
                files[i].isReadable() &&
                files[i].size() == testSize) {
                candidates << i;
            }
        }

        QList<int> confirmed;
        FileHashIterator testIterator(filePath);

        if (!candidates.isEmpty() && !testIterator.error() && _busy) {
            for (int candidateIndex : candidates) {
                if (!_busy) {
                    break;
                }

                const auto path = files[candidateIndex].filePath();
                emit testingCandidate(path);

                FileHashIterator candidateIterator(path);
                if (candidateIterator.error()) {
                    continue;
                }

                testIterator.restart();
                bool duplicate = false;

                while (_busy) {
                    const auto testHash = testIterator.getNextHash();
                    const auto candidateHash = candidateIterator.getNextHash();
                    if (testHash.isEmpty() && candidateHash.isEmpty()) {
                        duplicate = true;
                        break;
                    }
                    if (testHash.isEmpty() || candidateHash.isEmpty() || testHash != candidateHash) {
                        break;
                    }
                }

                if (duplicate) {
                    confirmed << candidateIndex;
                }
            }
        }

        if (_busy) {
            _busy = false;

            emit found(confirmed);
        }
    });
}

void DuplicatesFinder::cancel()
{
    _busy = false;
}
