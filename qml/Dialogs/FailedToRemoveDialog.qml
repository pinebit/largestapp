import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Dialog {
    id: root
    property var filePaths: []

    title: qsTr("WARNING")
    width: 500
    height: Math.min(200 + filePaths.length * 16, 400)

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 8

        Text {
            text: qsTr("These files cannot be deleted:")
            font.bold: true
            color: Material.color(Material.Red)
        }

        FilesListView {
            model: root.filePaths
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Close")
                onClicked: {
                    root.reject()
                }
            }
        }
    }
}
