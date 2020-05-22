import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Rectangle {
    id: root
    property string icon: MaterialIcons.icons.settings
    signal clicked

    width: 32
    height: 32
    radius: 32
    color: "transparent"
    border.width: mouseArea.containsMouse ? 1 : 0
    border.color: Material.backgroundDimColor

    MaterialIcon {
        anchors.centerIn: parent
        width: 24
        height: 24
        text: root.icon
        color: Material.primaryTextColor
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.clicked()
        }
    }
}
