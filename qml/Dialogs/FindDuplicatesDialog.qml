import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import Components 1.0
import NativeComponents 1.0

Dialog {
    id: root
    property QtObject context
    property string filePath
    property bool searching: false
    signal removeFiles(var paths)

    title: qsTr("FIND DUPLICATES")
    width: 500
    height: 300
    modal: true
    closePolicy: Popup.NoAutoClose

    onOpened: {
        root.searching = true
        finder.find(root.context, root.filePath)
    }

    onClosed: {
        finder.cancel()
        root.searching = false
    }

    DuplicatesFinder {
        id: finder

        onFound: {
            root.searching = false
            statusLabel.text = qsTr("Found %1 duplicate(s) for the selected file.").arg(duplicates.length)

            fileList.listModel.clear()
            duplicates.forEach(duplicate => {
                fileList.listModel.append(({
                                               "selected": true,
                                               "filePath": duplicate
                                           }))
            })
        }

        onTestingCandidate: {
            statusLabel.text = qsTr("Testing: %1").arg(filePath)
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
            id: statusLabel
            Layout.topMargin: 8
            color: Material.secondaryTextColor
            font.pixelSize: 14
            Layout.fillWidth: true
            elide: Text.ElideMiddle
        }

        CheckableFileListView {
            id: fileList
            Layout.fillHeight: true
            Layout.fillWidth: true
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
                    root.close()
                }
            }

            Button {
                visible: fileList.count > 0
                Material.foreground: Material.Red
                text: qsTr("DELETE FILES")
                font.bold: true
                onClicked: {
                    let removingFiles = []
                    for (let i = 0; i < fileList.listModel.count; ++i) {
                        let item = fileList.listModel.get(i)
                        if (item.selected) {
                            removingFiles.push(item.filePath)
                        }
                    }
                    if (removingFiles.length > 0) {
                        root.removeFiles(removingFiles)
                    }

                    root.close()
                }
            }
        }
    }
}

