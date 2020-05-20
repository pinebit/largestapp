import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Pane {
    id: root
    property QtObject context
    signal restartScanning

    Material.elevation: 4

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        RowLayout {
            Layout.fillWidth: true

            Text {
                Layout.alignment: Qt.AlignBottom
                text: qsTr("Top Largest Files:")
                color: Material.primaryHighlightedTextColor
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Restart Scanning")
                onClicked: {
                    root.restartScanning()
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Material.secondaryTextColor
        }

        ListView {
            id: fileListview
            Layout.fillWidth: true
            Layout.fillHeight: true

            clip: true
            focus: true
            keyNavigationEnabled: true
            currentIndex: -1

            model: context.files

            highlightFollowsCurrentItem: true
            highlight: Rectangle {
                color: Material.primaryColor
                radius: 2
            }

            ScrollBar.vertical: ScrollBar {
                visible: true
            }

            delegate: Item {
                width: fileListview.width - 20
                height: 32

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    spacing: 64

                    Text {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillWidth: true
                        color: Material.primaryTextColor
                        text: modelData
                        elide: Text.ElideMiddle
                    }

                    Text {
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        text: root.context.getFileSize(modelData)
                        color: Material.primaryHighlightedTextColor
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        fileListview.currentIndex = index
                    }
                }
            }
        }
    }
}
