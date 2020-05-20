import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import NativeComponents 1.0
import Icons 1.0

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
        scanning: appState.volumeStates[index] === VolumeStates.scanning
        width: root.width
        height: 64

        onVolumeSelected: {
            root.volumeSelected(index)
        }
    }
}
