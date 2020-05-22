import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Switch {
    text: qsTr("Ignore Hidden Files")
    checked: settings.ignoreHidden
    onCheckedChanged: {
        settings.ignoreHidden = checked
    }
}
