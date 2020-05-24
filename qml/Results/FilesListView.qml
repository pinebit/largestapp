import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQml.Models 2.2

import Dialogs 1.0

ListView {
    id: root
    property QtObject context

    clip: true
    focus: true
    interactive: true
    spacing: 2

    Keys.onEscapePressed: {
        selectionGroup.clear()
    }

    section.criteria: ViewSection.FullString
    section.property: "fileDir"
    section.delegate: Text {
        height: 24
        text: section
        elide: Text.ElideMiddle
        font.pixelSize: 14
        color: Material.secondaryTextColor
        verticalAlignment: Qt.AlignBottom
    }

    model: DelegateModel {
        id: visualModel
        model: context.resultsListModel
        groups: [
            DelegateModelGroup {
                id: selectionGroup
                name: "selected"

                function clear() {
                    if (count > 0) {
                        removeGroups(0, count, "selected")
                    }
                }

                function getFilePaths() {
                    let paths = []
                    for (let i = 0; i < count; ++i) {
                        paths.push(selectionGroup.get(i).model.filePath)
                    }
                    return paths
                }
            }
        ]

        delegate: FilesListViewDelegate {
            id: item
            multipleSelected: selectionGroup.count > 1
            selected: DelegateModel.inSelected
            width: root.width - 20
            height: 32
            onSelect: {
                root.forceActiveFocus()
                item.DelegateModel.inSelected = true

            }
            onToggleSelection: {
                root.forceActiveFocus()
                item.DelegateModel.inSelected = !item.DelegateModel.inSelected
            }
            onOpenContainingFolder: {
                root.context.openFile(model.fileDir)
            }
            onOpenFile: {
                root.context.openFile(model.filePath)
            }
            onDeleteFile: {
                confirmDeleteDialog.filePaths = selectionGroup.getFilePaths()
                confirmDeleteDialog.open()
            }
            onFindDuplicates: {
                findDuplicatesDialogLoader.open(model.filePath)
            }
        }
    }

    ScrollBar.vertical: ScrollBar {
        visible: true
    }

    ConfirmDeleteDialog {
        id: confirmDeleteDialog

        onAccepted: {
            selectionGroup.clear()

            let failedToRemove = []

            filePaths.forEach(path => {
                if (!root.context.deleteFile(path)) {
                    failedToRemove.push(path)
                }
            })

            if (failedToRemove.length > 0) {
                failedToRemoveDialog.filePaths = failedToRemove
                failedToRemoveDialog.open()
            }
        }
    }

    FailedToRemoveDialog {
        id: failedToRemoveDialog
    }

    Loader {
        id: findDuplicatesDialogLoader
        active: false

        function open(filePath) {
            active = true
            item.filePath = filePath
            item.open()
        }

        sourceComponent: FindDuplicatesDialog {
            context: root.context
            onClosed: {
                findDuplicatesDialogLoader.active = false
            }
            onRemoveFiles: {
                confirmDeleteDialog.filePaths = paths
                confirmDeleteDialog.open()
            }
        }
    }
}
