import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import Results 1.0

Pane {
    id: root
    property QtObject context
    signal restartScanning

    Material.elevation: 4

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        RowLayout {
            Layout.fillWidth: true

            Text {
                Layout.alignment: Qt.AlignBottom
                text: qsTr("Top Largest Files:")
                color: Material.primaryHighlightedTextColor
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Restart Scanning")
                onClicked: {
                    root.restartScanning()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Material.secondaryTextColor
        }

        FilesListView {
            context: root.context
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
