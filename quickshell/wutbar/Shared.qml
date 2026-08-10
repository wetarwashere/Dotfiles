pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

QtObject {
    property string songText: "Not Playing"
    property var allApps: []
    property Process appListProc: Process {
        command: ["bash", "-c", "for f in /usr/share/applications/*.desktop $HOME/.local/share/applications/*.desktop; do " + "[ -f \"$f\" ] || continue; " + "n=$(grep -m1 '^Name=' \"$f\" | cut -d= -f2-); " + "e=$(grep -m1 '^Exec=' \"$f\" | cut -d= -f2- | sed 's/%[a-zA-Z]//g'); " + "i=$(grep -m1 '^Icon=' \"$f\" | cut -d= -f2-); " + "[ -n \"$n\" ] && [ -n \"$e\" ] && echo \"$n|$e|$i\"; " + "done"]
        running: false
        stdout: SplitParser {
            onRead: line => {
                const parts = line.trim().split("|");

                if (parts[0] && parts[1]) {
                    const icon = parts[2] || "";

                    if (icon) {
                        Quickshell.iconPath(icon, "application-x-executable");
                    }

                    Shared.allApps = Shared.allApps.concat([
                        {
                            name: parts[0],
                            exec: parts[1],
                            icon: icon
                        }
                    ]);
                }
            }
        }
    }
    function refreshList() {
        allApps = [];
        appListProc.running = true;
    }
}
