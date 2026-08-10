import Quickshell
import QtQuick
import Quickshell.Io
import "."

Scope {
    Bar {}
    AppLauncher {}

    Process {
        id: playerProc
        property string result: ""

        command: ["bash", "-c", "playerctl -p spotify metadata --format '{{ title }}' --follow"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                Shared.songText = data.trim() || "Not Playing";
            }
        }
    }
}
