#include "SearchConfig.hpp"

SearchConfig::SearchConfig(QObject *parent)
    : QObject(parent)
{
}

int SearchConfig::maxTopFiles() const
{
    return _maxTopFiles;
}

int SearchConfig::minFileSize() const
{
    return _minFileSize;
}

bool SearchConfig::ignoreHidden() const
{
    return _ignoreHidden;
}
