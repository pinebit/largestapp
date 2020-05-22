import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import Components 1.0

Pane {
    id: root
    signal stopScanning()

    Material.elevation: 4

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32

        Text {
            Layout.alignment: Qt.AlignHCenter
            color: Material.primaryTextColor
            text: qsTr("Scanning is in progress, this may take some time...")
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
    }
}
