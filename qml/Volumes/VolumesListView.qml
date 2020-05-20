import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import LargeAppComponents 1.0
import Material 1.0

ListView {
    id: root
    signal volumeSelected(int index)

    Layout.preferredWidth: 200
    Layout.fillHeight: true

    model: StoragesListModel {
    }

    clip: true
    focus: true
    keyNavigationEnabled: true
    highlightFollowsCurrentItem: true
    highlight: Rectangle {
        color: Material.primaryColor
        radius: 4
    }

    delegate: VolumeListViewDelegate {
        width: root.width
        height: 64

        onVolumeSelected: {
            root.volumeSelected(index)
        }
    }
}
