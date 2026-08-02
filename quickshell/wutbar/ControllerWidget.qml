import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

PanelWindow {
    id: controllerWidget
    property bool revealed: false
    property bool buttonHovered: false

    implicitWidth: controllerWidgetContent.width + 12 * 2
    implicitHeight: controllerWidgetContent.height + 12 * 2
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    exclusiveZone: 0
    color: "transparent"
    mask: Region {
        item: controllerWidgetMouseArea
    }

    MouseArea {
        id: controllerWidgetMouseArea
        width: controllerWidget.revealed ? controllerWidgetContent.width + 12 * 2 : 10
        height: controllerWidgetContent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        hoverEnabled: true
        onEntered: {
            if (!controllerWidget.buttonHovered) {
                controllerWidget.revealed = true;
            }
        }
        onExited: {
            if (!controllerWidget.buttonHovered) {
                controllerWidget.revealed = false;
            }
        }
    }

    Item {
        anchors.fill: parent
        clip: true

        Rectangle {
            width: controllerWidgetContent.width + 12 * 2
            height: controllerWidgetContent.height + 12 * 2
            color: "#000000"
            border.color: "#ffffff"
            border.width: 2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: controllerWidget.revealed ? 0 : -width

            Behavior on anchors.leftMargin {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }

            Row {
                id: controllerWidgetContent
                anchors.centerIn: parent
                spacing: 15

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Rectangle {
                        color: muteButtonHoverHandler.hovered ? "#656565" : "#ffffff"
                        width: 40
                        height: 40

                        Text {
                            text: Pipewire.defaultAudioSink.audio.muted ? "" : " "
                            color: "#000000"
                            font.pixelSize: 18
                            font.family: "JetBrainsMono Nerd Font"
                            anchors.centerIn: parent
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 180
                            }
                        }

                        HoverHandler {
                            id: muteButtonHoverHandler
                            blocking: true
                            cursorShape: Qt.CursorShape.PointingHandCursor
                            onHoveredChanged: {
                                controllerWidget.buttonHovered = hovered;

                                if (hovered) {
                                    controllerWidget.revealed = true;
                                } else {
                                    if (!controllerWidgetMouseArea.containsMouse) {
                                        controllerWidget.revealed = false;
                                    }
                                }
                            }
                        }

                        TapHandler {
                            onTapped: Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
                        }
                    }

                    Rectangle {
                        id: loopButton
                        property int loopIndex: 0
                        property var loopStates: ["None", "Playlist", "Track"]
                        property string loopStatus: loopStates[loopIndex]

                        color: loopButtonHoverHandler.hovered ? "#656565" : "#ffffff"
                        width: 40
                        height: 40

                        Text {
                            text: {
                                switch (loopButton.loopStatus) {
                                case "Playlist":
                                    return "";
                                case "Track":
                                    return " ";
                                default:
                                    return "";
                                }
                            }
                            color: "#000000"
                            font.pixelSize: 18
                            font.family: "JetBrainsMono Nerd Font"
                            anchors.centerIn: parent
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 180
                            }
                        }

                        HoverHandler {
                            id: loopButtonHoverHandler
                            cursorShape: Qt.CursorShape.PointingHandCursor
                            blocking: true
                            onHoveredChanged: {
                                controllerWidget.buttonHovered = hovered;

                                if (hovered) {
                                    controllerWidget.revealed = true;
                                } else {
                                    if (!controllerWidgetMouseArea.containsMouse) {
                                        controllerWidget.revealed = false;
                                    }
                                }
                            }
                        }

                        TapHandler {
                            onTapped: {
                                loopButton.loopIndex = (loopButton.loopIndex + 1) % loopButton.loopStates.length;

                                Quickshell.execDetached(["playerctl", "-p", "spotify", "loop", loopButton.loopStatus]);
                            }
                        }
                    }
                }

                Column {
                    spacing: 8

                    Row {
                        Text {
                            id: volumeIcon
                            text: (Pipewire.defaultAudioSink.audio.muted || Pipewire.defaultAudioSink.audio.volume === 0) ? "[    " : "[    "
                            color: "#ffffff"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }

                        Item {
                            width: 200
                            height: 18
                            anchors.verticalCenter: parent.verticalCenter

                            MouseArea {
                                id: volumeMouseArea
                                anchors.fill: parent
                                cursorShape: Qt.CursorShape.PointingHandCursor
                                hoverEnabled: true
                                onMouseXChanged: {
                                    if (pressed) {
                                        updateVolume(mouseX);
                                    }
                                }
                                onPositionChanged: {
                                    if (pressed) {
                                        updateVolume(mouseX);
                                    }
                                }
                                onClicked: {
                                    updateVolume(mouseX);
                                }

                                function updateVolume(x) {
                                    var newValue = Math.max(0, Math.min(1, x / width));

                                    Pipewire.defaultAudioSink.audio.volume = newValue;

                                    if (newValue > 0 && Pipewire.defaultAudioSink.audio.muted) {
                                        Pipewire.defaultAudioSink.audio.muted = false;
                                    }
                                }
                            }

                            HoverHandler {
                                blocking: true
                                cursorShape: Qt.CursorShape.PointingHandCursor
                                onHoveredChanged: {
                                    controllerWidget.buttonHovered = hovered;

                                    if (hovered) {
                                        controllerWidget.revealed = true;
                                    } else {
                                        if (!controllerWidgetMouseArea.containsMouse) {
                                            controllerWidget.revealed = false;
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "#252525"
                            }

                            Rectangle {
                                width: Pipewire.defaultAudioSink.audio.muted ? 0 : (Pipewire.defaultAudioSink.audio.volume ?? 0) * 200
                                height: parent.height
                                color: "#ffffff"

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 180
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }
                        }

                        Text {
                            text: " ]"
                            color: "#ffffff"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }
                    }

                    Row {
                        Text {
                            id: brightnessIcon
                            text: Shared.brightness === 1 ? "[    " : "[ 󰃠   "
                            color: "#ffffff"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }

                        Item {
                            width: 200
                            height: 18
                            anchors.verticalCenter: parent.verticalCenter

                            MouseArea {
                                id: brightnessMouseArea
                                anchors.fill: parent
                                cursorShape: Qt.CursorShape.PointingHandCursor
                                hoverEnabled: true
                                onMouseXChanged: {
                                    if (pressed) {
                                        updateBrightness(mouseX);
                                    }
                                }
                                onPositionChanged: {
                                    if (pressed) {
                                        updateBrightness(mouseX);
                                    }
                                }
                                onClicked: {
                                    updateBrightness(mouseX);
                                }

                                function updateBrightness(x) {
                                    var newValue = Math.max(1, Math.min(100, Math.round((x / width) * 100)));

                                    Shared.brightness = newValue;
                                    Shared.requestBrightnessDebounce();
                                }
                            }

                            HoverHandler {
                                blocking: true
                                cursorShape: Qt.CursorShape.PointingHandCursor
                                onHoveredChanged: {
                                    controllerWidget.buttonHovered = hovered;

                                    if (hovered) {
                                        controllerWidget.revealed = true;
                                    } else {
                                        if (!controllerWidgetMouseArea.containsMouse) {
                                            controllerWidget.revealed = false;
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "#252525"
                            }

                            Rectangle {
                                width: Shared.brightness * 2
                                height: parent.height
                                color: "#ffffff"

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 180
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }
                        }

                        Text {
                            text: " ]"
                            color: "#ffffff"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }
                    }

                    Row {
                        Text {
                            id: musicVolumeIcon
                            text: Shared.musicVolume === 0 ? "[    " : "[    "
                            color: "#ffffff"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }

                        Item {
                            width: 200
                            height: 18
                            anchors.verticalCenter: parent.verticalCenter

                            MouseArea {
                                id: musicVolumeMouseArea
                                anchors.fill: parent
                                cursorShape: Qt.CursorShape.PointingHandCursor
                                hoverEnabled: true
                                onMouseXChanged: {
                                    if (pressed) {
                                        updateVolume(mouseX);
                                    }
                                }
                                onPositionChanged: {
                                    if (pressed) {
                                        updateVolume(mouseX);
                                    }
                                }
                                onClicked: {
                                    updateVolume(mouseX);
                                }

                                function updateVolume(x) {
                                    var newValue = Math.max(0, Math.min(1, x / width));

                                    Shared.musicVolume = newValue;
                                    Shared.requestMusicVolumeDebounce();
                                }
                            }

                            HoverHandler {
                                blocking: true
                                cursorShape: Qt.CursorShape.PointingHandCursor
                                onHoveredChanged: {
                                    controllerWidget.buttonHovered = hovered;

                                    if (hovered) {
                                        controllerWidget.revealed = true;
                                    } else {
                                        if (!controllerWidgetMouseArea.containsMouse) {
                                            controllerWidget.revealed = false;
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "#252525"
                            }

                            Rectangle {
                                width: Shared.musicVolume * 200
                                height: parent.height
                                color: "#ffffff"

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 180
                                        easing.type: Easing.OutCubic
                                    }
                                }
                            }
                        }

                        Text {
                            text: " ]"
                            color: "#ffffff"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }
                    }
                }
            }
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}
