import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Item {
    id: root
    property var descriptor
    signal selected
    signal openContainingFolder
    signal deleteFile

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 64

        Text {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            color: Material.primaryTextColor
            text: descriptor.filePath
            elide: Text.ElideMiddle
        }

        Text {
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            text: descriptor.fileSize
            color: Material.primaryHighlightedTextColor
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            root.selected()
            if (mouse.button === Qt.RightButton) {
                contextMenu.x = mouse.x
                contextMenu.y = mouse.y
                contextMenu.open()
            }
        }
        onPressAndHold: {
            if (mouse.source === Qt.MouseEventNotSynthesized) {
                contextMenu.x = mouse.x
                contextMenu.y = mouse.y
                contextMenu.open()
            }
        }
    }

    FileContextMenu {
        id: contextMenu
        onOpenFolder: {
            root.openContainingFolder()
        }
        onDeleteFile: {
            root.deleteFile()
        }
    }
}
