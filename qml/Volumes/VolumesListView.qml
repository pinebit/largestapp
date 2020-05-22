import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import NativeComponents 1.0
import Components 1.0

ListView {
    id: root
    property string selectedRootPath: ""

    Layout.preferredWidth: 200
    Layout.fillHeight: true
    currentIndex: -1
    clip: true
    focus: true
    keyNavigationEnabled: true
    highlightFollowsCurrentItem: false

    model: VolumesListModel {
        Component.onCompleted: {
            root.currentIndex = getDefaultIndex()
        }
    }

    highlight: Rectangle {
        width: root.width
        height: 64
        color: Material.primaryColor
        radius: 4
        y: root.currentItem.y
    }

    delegate: VolumeListViewDelegate {
        width: root.width
        height: 64

        onVolumeSelected: {
            root.currentIndex = index
        }
    }

    onCurrentItemChanged: {
        if (currentItem) {
            root.selectedRootPath = currentItem.rootPath
        }
    }
}
