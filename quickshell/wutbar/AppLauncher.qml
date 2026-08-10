import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import "."

PanelWindow {
    id: appLauncherWidget
    property bool revealed: false
    property bool buttonHovered: false
    property string query: ""

    implicitWidth: appLauncherWidgetContent.width + 24
    implicitHeight: appLauncherWidgetContent.height + 24
    anchors.left: true
    anchors.bottom: true
    exclusiveZone: 0
    color: "transparent"
    visible: false
    margins.bottom: 15
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    function toggle() {
        if (!appLauncherWidget.revealed) {
            Shared.refreshList();
            appLauncherWidget.visible = true;
            appLauncherWidget.revealed = true;
            appLauncherWidgetSearch.text = "";
            appLauncherWidgetSearch.forceActiveFocus();
        } else {
            appLauncherWidget.revealed = false;
        }
    }

    Item {
        anchors.fill: parent
        clip: true

        Rectangle {
            width: appLauncherWidgetContent.width + 24
            height: appLauncherWidgetContent.height + 24
            color: "#000000"
            anchors.left: parent.left
            anchors.verticalCenter: parent.horizontalCenter
            anchors.leftMargin: appLauncherWidget.revealed ? 0 : -width

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 2
                color: "#ffffff"
            }

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 2
                color: "#ffffff"
            }

            Rectangle {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: 2
                color: "#ffffff"
            }

            Behavior on anchors.leftMargin {
                NumberAnimation {
                    duration: 240
                    easing.type: Easing.OutCubic
                    onRunningChanged: {
                        if (!running && !appLauncherWidget.revealed) {
                            appLauncherWidget.visible = false;
                            appLauncherWidgetSearch.focus = false;
                        }
                    }
                }
            }

            Column {
                id: appLauncherWidgetContent
                width: 500
                anchors.centerIn: parent
                spacing: 8

                TextInput {
                    id: appLauncherWidgetSearch
                    width: parent.width
                    height: 30
                    color: "#ffffff"
                    font.pixelSize: 18
                    font.family: "JetBrainsMono Nerd Font"
                    clip: true
                    focus: true
                    onTextChanged: appLauncherWidget.query = text

                    Keys.onEscapePressed: appLauncherWidget.toggle()
                    Keys.onDownPressed: appLauncherAppList.currentIndex = Math.min(appLauncherAppList.currentIndex + 1, appLauncherAppList.count - 1)
                    Keys.onUpPressed: appLauncherAppList.currentIndex = Math.max(appLauncherAppList.currentIndex - 1, 0)
                    Keys.onReturnPressed: {
                        const app = appLauncherAppList.model[appLauncherAppList.currentIndex];

                        if (app) {
                            Quickshell.execDetached(["bash", "-c", app.exec]);
                            appLauncherWidget.toggle();
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 2
                    color: "#ffffff"
                }

                ListView {
                    id: appLauncherAppList
                    width: parent.width
                    height: 340
                    clip: true
                    currentIndex: 0
                    model: Shared.allApps.filter(a => a.name.toLowerCase().includes(appLauncherWidget.query.toLowerCase()))
                    anchors.topMargin: 20
                    header: Item {
                        height: 6
                    }

                    delegate: Rectangle {
                        width: appLauncherAppList.width
                        height: 40
                        color: ListView.isCurrentItem ? "#303030" : "transparent"

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            spacing: 14

                            IconImage {
                                width: 30
                                height: 30
                                anchors.verticalCenter: parent.verticalCenter
                                source: modelData.icon.startsWith("/") ? "file://" + modelData.icon : Quickshell.iconPath(modelData.icon, "application-x-executable")
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: modelData.name
                                color: "#ffffff"
                                font.pixelSize: 16
                                font.family: "JetBrainsMono Nerd Font"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                Quickshell.execDetached(["bash", "-c", modelData.exec]);
                                appLauncherWidget.toggle();
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "launcher"

        function toggle() {
            appLauncherWidget.toggle();
        }
    }
}
