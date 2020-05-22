import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ColumnLayout {
    spacing: 4

    Text {
        text: qsTr("Minimum File Size")
        color: Material.primaryTextColor
    }

    Text {
        wrapMode: Text.WordWrap
        text: qsTr("⏵files smaller than this size will be ignored")
        font.pixelSize: 12
        color: Material.secondaryTextColor
    }

    SpinBox {
        from: 0
        to: items.length - 1
        value: settings.minFileSize

        property var items: ["All Files", "1 Kb", "1 Mb", "1 Gb"]

        textFromValue: function (value) {
            return items[value]
        }

        valueFromText: function (text) {
            for (let i = 0; i < items.length; ++i) {
                if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0) {
                    return i
                }
            }
            return sb.value
        }

        onValueChanged: {
            settings.minFileSize = value
        }
    }
}
