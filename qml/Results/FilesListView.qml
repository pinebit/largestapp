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

    Keys.onEscapePressed: {
        selectionGroup.clear()
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
                Qt.openUrlExternally(model.fileDir)
            }
            onDeleteFile: {
                confirmDeleteDialog.filePaths = selectionGroup.getFilePaths()
                confirmDeleteDialog.open()
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
}
