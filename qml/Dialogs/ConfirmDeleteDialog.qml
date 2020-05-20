import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    id: root
    property string filePath

    title: qsTr("Warning")
    width: 500
    height: 200

    ColumnLayout {
        anchors.fill: parent

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr("This file will be PERMANENTLY deleted: %1").arg(filePath)
            font.bold: true
            color: Material.color(Material.DeepOrange)
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Cancel")
                onClicked: {
                    root.reject()
                }
            }

            Button {
                Material.foreground: Material.Red
                text: qsTr("Delete")
                font.bold: true
                onClicked: {
                    root.accept()
                }
            }
        }
    }
}
