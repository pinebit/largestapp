import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import Components 1.0

Pane {
    id: root
    property QtObject context
    signal stopScanning()

    Material.elevation: 4

    Connections {
        target: context
        onStatusUpdated: {
            if (statusLabel.text !== status) {
                statusLabel.text = status
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 32

        Item {
            Layout.fillHeight: true
        }

        Text {
            Layout.alignment: Qt.AlignCenter
            color: Material.primaryTextColor
            text: qsTr("Scanning is in progress, this may take some time...")
        }

        Text {
            id: statusLabel
            Layout.maximumWidth: root.width - 64
            Layout.alignment: Qt.AlignHCenter
            color: Material.secondaryTextColor
            font.pixelSize: 12
            elide: Text.ElideMiddle
        }

        AnimatedScanningIcon {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 24
            Layout.preferredWidth: 24
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Stop Scanning")
            Material.background: Material.color(Material.Red)
            onClicked: {
                stopScanning()
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
