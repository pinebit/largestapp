import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Switch {
    text: qsTr("Delete Moves To Trash")
    checked: settings.moveToTrash
    onCheckedChanged: {
        settings.moveToTrash = checked
    }
}
