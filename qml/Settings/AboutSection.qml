import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ColumnLayout {
    spacing: 8

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: qsTr("Version: %1").arg(version)
        font.pixelSize: 10
        color: Material.secondaryTextColor
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: "<a href=\"largestapp.com\">largestapp.com</a>"
        font.pixelSize: 12
        font.bold: true
        linkColor: Qt.lighter(Material.primaryColor)
        onLinkActivated: {
            Qt.openUrlExternally("https://largestapp.com")
        }
    }
}
