import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Pane {
    id: root
    signal startScanning()

    Material.elevation: 4

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 32

        Text {
            Layout.alignment: Qt.AlignHCenter
            color: Material.primaryTextColor
            text: qsTr("This drive needs to be scanned to find all large files.")
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Start Scanning")
            onClicked: {
                startScanning()
            }
        }
    }
}
