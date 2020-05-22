import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Menu {
    property bool multiple: false
    signal openFolder
    signal deleteFile
    implicitWidth: 250

    MenuItem {
        text: qsTr("Open containing folder...")
        onTriggered: {
            openFolder()
        }
    }

    MenuSeparator {
    }

    MenuItem {
        text: multiple ? qsTr("Delete these files...") : qsTr("Delete this file...")
        onTriggered: {
            deleteFile()
        }
    }
}
