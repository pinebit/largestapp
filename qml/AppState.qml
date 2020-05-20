import QtQuick 2.12
import Volumes 1.0

QtObject {
    property int currentVolume: 0
    property var volumeStates: []
    property int currentVolumeState: volumeStates[currentVolume] || VolumeStates.idle
}
