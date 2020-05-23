TEMPLATE = app
TARGET = LargestApp

QT += core quick quickcontrols2 concurrent
CONFIG += c++17 qtquickcompiler

DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += VERSION=\\\"$$system(git describe --always --abbrev=0)\\\"

SOURCES += \
    src/DuplicatesFinder.cpp \
    src/FileHashIterator.cpp \
    src/ResultsListModel.cpp \
    src/SearchConfig.cpp \
    src/SearchContext.cpp \
    src/SearchEngine.cpp \
    src/VolumesListModel.cpp \
    src/main.cpp

HEADERS += \
    src/DuplicatesFinder.hpp \
    src/FileHashIterator.hpp \
    src/ResultsListModel.hpp \
    src/SearchConfig.hpp \
    src/SearchContext.hpp \
    src/SearchEngine.hpp \
    src/SearchState.hpp \
    src/VolumesListModel.hpp

RESOURCES += \
    resources.qrc \
    qml.qrc

QML2_IMPORT_PATH += $$PWD/qml
QML_IMPORT_PATH += $$PWD/qml

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RC_ICONS = app.ico
