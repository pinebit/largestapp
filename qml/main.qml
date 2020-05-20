import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import Volumes 1.0

ApplicationWindow {
    visible: true
    minimumWidth: 800
    minimumHeight: 600

    QtObject {
        id: appState
        property int currentVolume: 0
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

        Pane {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Material.elevation: 4

            RowLayout {
                spacing: 16

                Button {
                    text: qsTr("Largest Files")
                }

                Button {
                    text: qsTr("Largest Folders")
                }

                Button {
                    text: qsTr("File Duplicates")
                }

            }
        }
    }
}
