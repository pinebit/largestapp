import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ListView {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true

    delegate: Text {
        width: root.width - 16
        elide: Text.ElideMiddle
        text: modelData
        color: Material.secondaryTextColor
    }
}
