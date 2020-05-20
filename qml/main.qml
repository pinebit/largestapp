import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import Volumes 1.0
import NativeComponents 1.0

ApplicationWindow {
    visible: true
    minimumWidth: 800
    minimumHeight: 600

    SearchEngine {
        id: searchEngine
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
                onStopScanning: {
                    paneLoader.searchContext.stop()
                }
            }
        }

        Component {
            id: resultsPaneComponent
            Pane {
            }
        }
    }
}
