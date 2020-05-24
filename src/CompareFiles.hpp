#ifndef COMPAREFILES_HPP
#define COMPAREFILES_HPP

#include <QString>
#include <atomic>

namespace CompareFiles
{
// returns true if the two files are duplicates.
bool compare(const QString &filePath1,
             const QString &filePath2,
             std::atomic<bool> &running);
};

#endif // COMPAREFILES_HPP
