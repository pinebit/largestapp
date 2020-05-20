import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import Volumes 1.0

ApplicationWindow {
    visible: true
    minimumWidth: 800
    minimumHeight: 600

    AppState {
        id: appState
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        VolumesListView {
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            currentIndex: appState.currentVolume
            onVolumeSelected: {
                appState.currentVolume = index
            }
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true

            sourceComponent: {
                const state = appState.currentVolumeState
                switch (state) {
                case VolumeStates.idle:
                    return startScanPaneComponent
                case VolumeStates.scanning:
                    return scanningPaneComponent
                }
            }
        }

        Component {
            id: startScanPaneComponent
            StartScanPane {
                onStartScanning: {
                    let newStates = appState.volumeStates.slice()
                    newStates[appState.currentVolume] = VolumeStates.scanning
                    appState.volumeStates = newStates
                }
            }
        }

        Component {
            id: scanningPaneComponent
            ScanningPane {
                onStopScanning: {
                    let newStates = appState.volumeStates.slice()
                    newStates[appState.currentVolume] = VolumeStates.idle
                    appState.volumeStates = newStates
                }
            }
        }
    }
}
