#include "CompareFiles.hpp"
#include <QFile>
#include <QFileInfo>
#include <QDebug>

bool CompareFiles::compare(const QString &filePath1,
                           const QString &filePath2,
                           std::atomic<bool> &running)
{
    QFile file1(filePath1);
    QFile file2(filePath2);

    if (!file1.open(QIODevice::ReadOnly) || !file2.open(QIODevice::ReadOnly)) {
        return false;
    }

    while (running) {
        const int BlockSize = 64 * 1024;
        const auto data1 = file1.read(BlockSize);
        const auto data2 = file2.read(BlockSize);
        if (data1 != data2) {
            return false;
        }
        if (data1.isEmpty()) {
            break;
        }
    }

    file1.close();
    file2.close();

    return running;
}
