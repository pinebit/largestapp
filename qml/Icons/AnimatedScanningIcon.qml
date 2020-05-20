import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import Icons 1.0

MaterialIcon {
    text: MaterialIcons.icons.cached
    color: Material.primaryHighlightedTextColor

    RotationAnimator on rotation {
        from: 360
        to: 0
        duration: 1000
        loops: Animation.Infinite
    }
}
