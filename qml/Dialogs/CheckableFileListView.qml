import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

ListView {
    id: root
    property alias listModel: listModel

    Layout.fillWidth: true
    Layout.fillHeight: true
    clip: true
    model: ListModel {
        id: listModel
    }

    delegate: RowLayout {
        spacing: 16

        CheckBox {
            Layout.alignment: Qt.AlignVCenter
            checked: model.selected
            onToggled: {
                let item = listModel.get(index)
                item.selected = checked
                listModel.set(index, item)
            }
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            Layout.maximumWidth: root.width - 64
            elide: Text.ElideMiddle
            text: model.filePath
            color: Material.secondaryTextColor
        }
    }

    ScrollBar.vertical: ScrollBar {
        visible: true
    }
}
