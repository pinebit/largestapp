import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Qt.labs.settings 1.1

import Volumes 1.0
import Settings 1.0
import Components 1.0
import NativeComponents 1.0

ApplicationWindow {
    visible: true
    minimumWidth: 800
    minimumHeight: 600

    Settings {
        id: appSettings
        property int maxTopFiles: 100
        property int minFileSize: 2
        property bool ignoreHidden: true
    }

    SearchEngine {
        id: searchEngine
        config.maxTopFiles: appSettings.maxTopFiles
        config.minFileSize: {
            switch (appSettings.minFileSize) {
            case 1: return 1024
            case 2: return 1024 * 1024
            case 3: return 1024 * 1024 * 1024
            }
            return 0
        }
        config.ignoreHidden: appSettings.ignoreHidden
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        VolumesListView {
            id: volumeSelector
            Layout.preferredWidth: 200
            Layout.fillHeight: true
        }

        Loader {
            id: paneLoader
            property QtObject searchContext: searchEngine.getSearchContext(volumeSelector.selectedRootPath)
            Layout.fillWidth: true
            Layout.fillHeight: true

            sourceComponent: {
                if (searchContext.isSearching) {
                    return scanningPaneComponent
                }
                if (searchContext.isCompleted) {
                    return resultsPaneComponent
                }
                return startScanPaneComponent
            }
        }

        Component {
            id: startScanPaneComponent
            StartScanPane {
                onStartScanning: {
                    paneLoader.searchContext.restart()
                }
            }
        }

        Component {
            id: scanningPaneComponent
            ScanningPane {
                context: paneLoader.searchContext
                onStopScanning: {
                    paneLoader.searchContext.stop()
                }
            }
        }

        Component {
            id: resultsPaneComponent
            ResultsPane {
                context: paneLoader.searchContext
                onRestartScanning: {
                    paneLoader.searchContext.restart()
                }
            }
        }
    }

    IconButton {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 20
        icon: MaterialIcons.icons.settings
        onClicked: {
            settingsDrawer.open()
        }
    }

    SettingsDrawer {
        id: settingsDrawer
        settings: appSettings
    }
}
