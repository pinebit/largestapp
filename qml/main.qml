import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import LargeAppComponents 1.0
import "MaterialIcons.js" as MI

ApplicationWindow {
    visible: true
    minimumWidth: 800
    minimumHeight: 600

    QtObject {
        id: appState
        property int currentVolume: 0
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        ListView {
            id: volumesListView
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            currentIndex: appState.currentVolume

            model: StoragesListModel {
            }

            highlightFollowsCurrentItem: true
            highlight: Rectangle {
                color: Material.primaryColor
                radius: 4
            }

            delegate: Item {
                width: volumesListView.width
                height: 64

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    MaterialIcon {
                        Layout.alignment: Qt.AlignVCenter
                        text: MI.icons.dns
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
                        appState.currentVolume = index
                    }
                }
            }
        }

        Pane {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Material.elevation: 4

            RowLayout {
                spacing: 16

                Button {
                    text: qsTr("Largest Files")
                }

                Button {
                    text: qsTr("Largest Folders")
                }

                Button {
                    text: qsTr("File Duplicates")
                }

            }
        }
    }
}
