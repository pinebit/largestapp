import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import Icons 1.0

Item {
    id: root
    property bool scanning: false
    signal volumeSelected(int index)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        AnimatedScanningIcon {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            visible: root.scanning
        }

        MaterialIcon {
            Layout.alignment: Qt.AlignVCenter
            visible: !root.scanning
            text: MaterialIcons.icons.dns
        }

        ColumnLayout {
            spacing: 8

            Text {
                Layout.alignment: Qt.AlignLeft
                text: qsTr("%1 (%2)").arg(model.displayName).arg(model.rootPath)
                color: Material.foreground
            }

            Rectangle {
                Layout.fillWidth: true
                height: 8
                color: Material.backgroundDimColor

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width - parent.width * model.spaceAvailable
                    color: {
                        if (model.spaceAvailable < 0.2) {
                            return Material.color(Material.Red)
                        }
                        return Material.primaryHighlightedTextColor
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.volumeSelected(index)
        }
    }
}
