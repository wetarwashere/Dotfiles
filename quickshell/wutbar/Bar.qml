import Quickshell
import Quickshell.Networking
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import QtQuick.Layouts
import QtQuick
import Niri
import "."

PanelWindow {
    id: barWidget
    anchors.left: true
    implicitHeight: 738
    implicitWidth: 54
    margins.left: 16
    color: "transparent"

    function getBatteryIcon() {
        if (batteryWidget.isCharging) {
            return "󰂄";
        }

        switch (true) {
        case batteryWidget.batteryPercentage >= 90:
            return "󰂂";
        case batteryWidget.batteryPercentage >= 80:
            return "󰂁";
        case batteryWidget.batteryPercentage >= 70:
            return "󰁿";
        case batteryWidget.batteryPercentage >= 60:
            return "󰁾";
        case batteryWidget.batteryPercentage >= 50:
            return "󰁾";
        case batteryWidget.batteryPercentage >= 40:
            return "󰁽";
        case batteryWidget.batteryPercentage >= 30:
            return "󰁼";
        case batteryWidget.batteryPercentage >= 20:
            return "󰁻";
        case batteryWidget.batteryPercentage >= 10:
            return "󰁺";
        default:
            return "󰁹";
        }
    }

    function getVolumeIcon() {
        if (Pipewire.defaultAudioSink.audio.muted) {
            return "";
        }

        switch (true) {
        case volumeWidget.volumePercentage <= 0:
            return "";
        case volumeWidget.volumePercentage < 33:
            return "";
        case volumeWidget.volumePercentage < 66:
            return "";
        default:
            return "";
        }
    }

    function getWifiIcon() {
        switch (true) {
        case Networking.connectivity === NetworkConnectivity.Full:
            return "󰤨";
        case Networking.connectivity === NetworkConnectivity.Limited:
            return "󰤩";
        case Networking.connectivity === NetworkConnectivity.Portal:
            return "󰤪";
        default:
            return "󰤮";
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Niri {
        id: niriConnection
        Component.onCompleted: connect()
        onConnected: console.log("Connected to niri successfully")
        onErrorOccurred: function (error) {
            console.error("Failed to connect: ", error);
        }
    }

    SystemClock {
        id: clockData
        precision: SystemClock.Minutes
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        border.width: 2
        border.color: "#ffffff"

        ColumnLayout {
            anchors.fill: parent
            spacing: 6

            Rectangle {
                id: essentialsWidget
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 8
                Layout.preferredWidth: essentialsWidgetContent.implicitWidth
                Layout.preferredHeight: essentialsWidgetContent.implicitHeight
                color: "transparent"

                Column {
                    id: essentialsWidgetContent
                    anchors.centerIn: parent

                    Rectangle {
                        id: batteryWidget
                        property var batteryDevice: UPower.displayDevice
                        property int batteryPercentage: Math.round((batteryDevice?.percentage ?? 0) * 100)
                        property bool isCharging: batteryDevice?.state === UPowerDeviceState.Charging

                        width: batteryIcon.implicitHeight + 8
                        height: batteryIcon.implicitWidth + 28
                        color: "#303030"

                        Text {
                            id: batteryIcon
                            text: barWidget.getBatteryIcon()
                            anchors.centerIn: parent
                            color: "#ffffff"
                            font.weight: 900
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 22
                        }
                    }

                    Rectangle {
                        id: volumeWidget
                        property int volumePercentage: Pipewire.defaultAudioSink.audio.volume * 100

                        width: volumeIcon.implicitHeight + 16
                        height: volumeIcon.implicitWidth + 28
                        color: "#303030"

                        Text {
                            id: volumeIcon
                            text: barWidget.getVolumeIcon()
                            anchors.centerIn: parent
                            color: "#ffffff"
                            font.weight: 900
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 16
                        }
                    }

                    Rectangle {
                        id: wifiWidget
                        width: wifiIcon.implicitHeight + 14
                        height: wifiIcon.implicitWidth + 28
                        color: "#303030"

                        Text {
                            id: wifiIcon
                            text: barWidget.getWifiIcon()
                            anchors.centerIn: parent
                            color: "#ffffff"
                            font.weight: 900
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 18
                        }
                    }
                }
            }

            Rectangle {
                id: musicWidget
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: musicWidgetText.implicitHeight + 16
                Layout.preferredHeight: musicWidgetText.implicitWidth + 28
                color: "#303030"

                Text {
                    id: musicWidgetText
                    anchors.centerIn: parent
                    text: Shared.songText
                    color: "#ffffff"
                    font.weight: 900
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                    transformOrigin: Item.Center
                    rotation: -90
                }
            }

            Item {
                Layout.fillHeight: true
            }

            Rectangle {
                id: workspacesWidget
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: workspacesWidgetContent.implicitWidth + 22
                Layout.preferredHeight: workspacesWidgetContent.implicitHeight + 28
                color: "#303030"

                Column {
                    id: workspacesWidgetContent
                    anchors.centerIn: parent
                    spacing: 4

                    Repeater {
                        model: niriConnection.workspaces
                        delegate: Rectangle {
                            required property var model

                            width: 16
                            height: model.isFocused ? 40 : 30
                            color: model.isFocused ? "#ffffff" : "#151515"
                        }
                    }
                }
            }

            Rectangle {
                id: clockWidget
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: clockWidgetContent.implicitWidth + 12
                Layout.preferredHeight: clockWidgetContent.implicitHeight + 12
                color: "#303030"

                Column {
                    id: clockWidgetContent
                    anchors.centerIn: parent

                    Text {
                        text: Qt.formatTime(clockData.date, "hh")
                        color: "#ffffff"
                        font.weight: 900
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 22
                    }

                    Text {
                        text: Qt.formatTime(clockData.date, "mm")
                        color: "#ffffff"
                        font.weight: 900
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 22
                    }
                }
            }

            Rectangle {
                id: powerWidget
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 8
                Layout.preferredWidth: powerWidgetIcon.implicitHeight + 6
                Layout.preferredHeight: powerWidgetIcon.implicitWidth + 18
                color: powerWidgetHoverHandler.hovered ? "#353535" : "#303030"

                Behavior on color {
                    ColorAnimation {
                        duration: 180
                    }
                }

                HoverHandler {
                    id: powerWidgetHoverHandler
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    id: powerWidgetTapHandler
                    onTapped: {
                      Quickshell.execDetached(["bash", "-c", "qs -c wutbar ipc call launcher toggle"])
                    }
                }

                Text {
                    id: powerWidgetIcon
                    anchors.centerIn: parent
                    text: "󰣇"
                    color: "#ffffff"
                    font.weight: 900
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 24
                }
            }
        }
    }
}
