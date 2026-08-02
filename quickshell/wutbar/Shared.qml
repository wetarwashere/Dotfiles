pragma Singleton

import QtQuick

QtObject {
    signal requestBrightnessDebounce
    signal requestMusicVolumeDebounce

    property string titleText: "Nothing"
    property string titleIcon: " "
    property string artistText: "Nothing"
    property string artistIcon: " "
    property string artUrl: ""
    property string githubUsername: "insert.myself"
    property string username: ""
    property string distro: ""
    property string windowManager: ""
    property real brightness: 1
    property real musicVolume: 0
    property bool isPlaying: false
    property var levels: []
    property var allApps: []
}
