import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import Components 1.0

Dialog {
    id: root
    property QtObject context
    property string filePath
    property bool searching: false
    property int duplicatesCount: 0

    title: qsTr("FIND DUPLICATES")
    width: 500
    height: 200
    modal: true
    closePolicy: Popup.NoAutoClose

    onOpened: {
        root.searching = true
        root.context.findDuplicates(filePath)
    }

    onRejected: {
        close()
    }

    onClosed: {
        root.context.cancelFindingDuplicates()
        root.searching = false
    }

    Connections {
        target: root.context
        onDuplicatesFound: {
            root.searching = false
            root.duplicatesCount = count
            if (count > 0) {
                statusLabel.text = qsTr("The file list is updated to show duplicates.")
            } else {
                statusLabel.text = root.filePath
            }
        }
        onStatusUpdated: {
            statusLabel.text = status
        }
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 8

        RowLayout {
            visible: root.searching
            spacing: 16

            AnimatedScanningIcon {
                Layout.preferredHeight: 24
                Layout.preferredWidth: 24
            }

            Text {
                text: qsTr("Searching for duplicates...")
                color: Material.primaryTextColor
            }
        }

        Text {
            visible: !root.searching
            text: root.duplicatesCount == 0 ?
                      qsTr("No duplicates were found for the selected file:") :
                      qsTr("Found %1 duplicate(s) for the selected file.").arg(root.duplicatesCount)
            font.bold: true
            color: root.duplicatesCount == 0 ? Material.primaryTextColor : Material.color(Material.Red)
        }

        Text {
            id: statusLabel
            Layout.topMargin: 8
            color: Material.secondaryTextColor
            font.pixelSize: 14
            Layout.fillWidth: true
            elide: Text.ElideMiddle
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: root.searching ? qsTr("CANCEL") : qsTr("CLOSE")
                onClicked: {
                    root.reject()
                }
            }
        }
    }
}
