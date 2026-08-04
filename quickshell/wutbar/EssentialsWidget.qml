import QtQuick
import Quickshell
import Quickshell.Networking
import Quickshell.Services.UPower

PanelWindow {
    id: essentialsWidget
    property bool revealed: false
    property bool buttonHovered: false
    property var wifiDevice: null

    Connections {
        target: Networking.devices

        function onValuesChanged() {
            let found = null;
            for (const device of Networking.devices.values) {
                if (device.type === DeviceType.Wifi && (device.name === "wlan1" | device.name === "wlan0")) {
                    found = device;
                    break;
                }
            }
            essentialsWidget.wifiDevice = found;
            if (found)
                found.scannerEnabled = true;
        }
    }

    Component.onCompleted: {
        for (const device of Networking.devices.values) {
            if (device.type === DeviceType.Wifi && (device.name === "wlan1" | device.name === "wlan0")) {
                wifiDevice = device;
                wifiDevice.scannerEnabled = true;
                break;
            }
        }
    }
    anchors.top: true
    anchors.right: true
    implicitWidth: essentialsWidgetContent.width + 12 * 2
    implicitHeight: essentialsWidgetContent.height + 12 * 2.2
    exclusiveZone: 0
    color: "transparent"
    mask: Region {
        item: essentialsWidgetMouseArea
    }

    SystemClock {
        id: clockData
        precision: SystemClock.Minutes
    }

    MouseArea {
        id: essentialsWidgetMouseArea
        width: essentialsWidgetContent.width + 12 * 2
        height: essentialsWidget.revealed ? essentialsWidgetContent.height + 12 * 2.2 : 10
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        hoverEnabled: true
        onEntered: {
            if (!essentialsWidget.buttonHovered) {
                essentialsWidget.revealed = true;
            }
        }
        onExited: {
            if (!essentialsWidget.buttonHovered) {
                essentialsWidget.revealed = false;
            }
        }
    }

    Item {
        anchors.fill: parent
        clip: true

        Rectangle {
            width: parent.width
            height: 50
            color: "#000000"
            border.color: "#ffffff"
            border.width: 2
            y: essentialsWidget.revealed ? 0 : -height

            Behavior on y {
                NumberAnimation {
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }

            Row {
                id: essentialsWidgetContent
                anchors.centerIn: parent
                spacing: 8

                Row {
                    id: dateWidget

                    Text {
                        id: dateIcon
                        text: "[ 󰃭"
                        color: "#ffffff"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }

                    Text {
                        id: dateLabel
                        text: " " + Qt.formatDate(clockData.date, "dd.MM.yyyy") + " ]"
                        color: "#ffffff"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }
                }

                Row {
                    id: batteryWidget
                    visible: batteryDevice?.isLaptopBattery ?? false

                    property var batteryDevice: UPower.displayDevice
                    property int batteryPercentage: Math.round((batteryDevice?.percentage ?? 0) * 100)
                    property bool isCharging: batteryDevice?.state === UPowerDeviceState.Charging

                    Text {
                        id: batteryIcon
                        text: batteryWidget.isCharging ? "[ 󰂄" : "[ 󰁹"
                        color: "#ffffff"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }

                    Text {
                        id: batteryLabel
                        text: " " + batteryWidget.batteryPercentage + "% ]"
                        color: "#ffffff"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }
                }

                Row {
                    Text {
                        id: wifiIcon
                        text: Networking.connectivity === NetworkConnectivity.Full ? "[ " : "[ "
                        color: "#ffffff"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }

                    Text {
                        id: wifiLabel
                        property var activeNetwork: {
                            if (!essentialsWidget.wifiDevice)
                                return null;
                            for (const net of essentialsWidget.wifiDevice.networks.values) {
                                if (net.connected)
                                    return net;
                            }
                            return null;
                        }

                        text: activeNetwork ? " " + activeNetwork.name + " ]" : " Disconnect ]"
                        color: "#ffffff"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }
                }

                Row {
                    Text {
                        id: clockIcon
                        text: "[ "
                        color: "#ffffff"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }

                    Text {
                        id: clockLabel
                        text: " " + Qt.formatTime(clockData.date, "hh:mm") + " ]"
                        color: "#ffffff"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                    }
                }
            }
        }
    }
}
