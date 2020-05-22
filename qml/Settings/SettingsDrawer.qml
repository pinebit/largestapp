import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Qt.labs.settings 1.1

import Components 1.0

Drawer {
    id: root
    property Settings settings

    edge: Qt.LeftEdge
    width: 300
    height: parent.height
    dim: false

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: qsTr("SETTINGS")
                color: Material.primaryTextColor
            }

            Item {
                Layout.fillWidth: true
            }

            IconButton {
                icon: MaterialIcons.icons.close
                onClicked: {
                    root.close()
                }
            }
        }

        MenuSeparator {
            Layout.fillWidth: true
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 16

            FileSizeSetting {
                Layout.fillWidth: true
            }

            MaxTopFilesSetting {
                Layout.fillWidth: true
            }

            IgnoreHiddenFilesSetting {
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
