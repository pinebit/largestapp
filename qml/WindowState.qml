import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import Qt.labs.settings 1.0

Item {
    property Window window

    property int defaultX: (Screen.width - defaultWidth) / 2
    property int defaultY: (Screen.height - defaultHeight) / 2
    property int defaultWidth: 800
    property int defaultHeight: 500
    property bool defaultMaximised: false

    Settings {
        id: windowStateSettings
        category: "WindowState"
        property int x
        property int y
        property int width
        property int height
        property bool maximised
    }

    function restore() {
        if (windowStateSettings.width === 0 || windowStateSettings.height === 0) {
            curX = defaultX
            curY = defaultY
            curWidth = defaultWidth
            curHeight = defaultHeight
            curMaximised = defaultMaximised
        } else {
            curX = windowStateSettings.x
            curY = windowStateSettings.y
            curWidth = windowStateSettings.width
            curHeight = windowStateSettings.height
            curMaximised = windowStateSettings.maximised
        }

        window.x = prevX = curX
        window.y = prevY = curY
        window.width = prevWidth = curWidth
        window.height = prevHeight = curHeight

        if (curMaximised) {
            window.visibility = Window.Maximized
        }

        if (window.visibility === Window.Hidden) {
            window.visibility = Window.Windowed
        }
    }

    property int curX
    property int curY
    property int curWidth
    property int curHeight
    property bool curMaximised
    property int prevX
    property int prevY
    property int prevWidth
    property int prevHeight

    Connections {
        target: window
        onVisibilityChanged: {
            if (window.visibility === Window.Maximized) {
                curMaximised = true
                curX = prevX
                curY = prevY
                curWidth = prevWidth
                curHeight = prevHeight
            } else if (window.visibility === Window.Windowed) {
                curMaximised = false
            } else if (window.visibility === Window.Hidden) {
                windowStateSettings.x = curX
                windowStateSettings.y = curY
                windowStateSettings.width = curWidth
                windowStateSettings.height = curHeight
                windowStateSettings.maximised = curMaximised
            }
        }

        onXChanged: {
            prevX = curX
            curX = window.x
        }
        onYChanged: {
            prevY = curY
            curY = window.y
        }
        onWidthChanged: {
            prevWidth = curWidth
            curWidth = window.width
        }
        onHeightChanged: {
            prevHeight = curHeight
            curHeight = window.height
        }
    }
}
