import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

import Dialogs 1.0

ListView {
    id: root
    property QtObject context

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

    delegate: FilesListViewDelegate {
        width: root.width - 20
        height: 32
        descriptor: ({
                         "filePath": modelData,
                         "fileSize": root.context.getFileSize(modelData)
                     })
        onSelected: {
            root.currentIndex = index
        }
        onOpenContainingFolder: {
            const folder = root.context.getFileDirectory(modelData)
            Qt.openUrlExternally(folder)
        }
        onDeleteFile: {
            confirmDeleteDialog.filePath = modelData
            confirmDeleteDialog.open()
        }
    }

    ConfirmDeleteDialog {
        id: confirmDeleteDialog

        onAccepted: {
            root.context.deleteFile(filePath)
        }
    }
}
