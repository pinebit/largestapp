import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ColumnLayout {
    spacing: 4

    Text {
        text: qsTr("Maximum Top Files")
        color: Material.primaryTextColor
    }

    Text {
        wrapMode: Text.WordWrap
        text: qsTr("⏵limit the number of files shown in the results")
        font.pixelSize: 12
        color: Material.secondaryTextColor
    }

    SpinBox {
        from: 100
        to: 1000
        stepSize: 100
        value: settings.maxTopFiles
        onValueChanged: {
            settings.maxTopFiles = value
        }
    }
}
