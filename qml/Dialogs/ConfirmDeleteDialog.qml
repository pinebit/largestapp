import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    id: root
    property var filePaths: []

    title: qsTr("Warning")
    width: 500
    height: Math.min(200 + filePaths.length * 16, 400)

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 8

        Text {
            Layout.fillWidth: true
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: root.filePaths.length === 1 ?
                      qsTr("This file will be PERMANENTLY deleted:") :
                      qsTr("These %1 files will be PERMANENTLY deleted:").arg(root.filePaths.length)
            font.bold: true
            color: Material.color(Material.Red)
        }

        ListView {
            id: filesListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: root.filePaths

            delegate: Text {
                width: filesListView.width - 16
                elide: Text.ElideMiddle
                text: modelData
                color: Material.secondaryTextColor
            }
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
