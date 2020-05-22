import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import Results 1.0

Pane {
    id: root
    property QtObject context
    signal restartScanning

    Material.elevation: 4

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        anchors.topMargin: 0
        spacing: 8

        RowLayout {
            Layout.fillWidth: true

            Text {
                color: Material.primaryTextColor
                text: qsTr("Largest Files:")
            }

            Switch {
                text: qsTr("Group By Folder")
                checked: appSettings.groupByFolders
                onCheckedChanged: {
                    appSettings.groupByFolders = checked
                    root.context.resultsListModel.setGroupByFolders(checked)
                }
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

        FilesListView {
            id: filesListView
            visible: filesListView.count > 0
            context: root.context
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Item {
            visible: !filesListView.visible
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                anchors.centerIn: parent
                color: Material.primaryHighlightedTextColor
                text: qsTr("No files were found.")
            }
        }
    }
}
