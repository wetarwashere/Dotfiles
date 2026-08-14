pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

QtObject {
    property string songText: "Not Playing"
    property var allApps: []
    property var seenApps: ({})
    property Process appListProc: Process {
        command: ["bash", "-c", "declare -A seen; " + "for f in $HOME/.local/share/applications/*.desktop /usr/share/applications/*.desktop; do " + "[ -f \"$f\" ] || continue; " + "id=$(basename \"$f\"); " + "[ -n \"${seen[$id]}\" ] && continue; " + "seen[$id]=1; " + "grep -q '^NoDisplay=true' \"$f\" && continue; " + "n=$(grep -m1 '^Name=' \"$f\" | cut -d= -f2-); " + "e=$(grep -m1 '^Exec=' \"$f\" | cut -d= -f2- | sed 's/%[a-zA-Z]//g'); " + "i=$(grep -m1 '^Icon=' \"$f\" | cut -d= -f2-); " + "[ -n \"$n\" ] && [ -n \"$e\" ] && echo \"$n|$e|$i\"; " + "done"]
        running: false
        stdout: SplitParser {
            onRead: line => {
                const parts = line.trim().split("|");

                if (parts[0] && parts[1]) {
                    const key = parts[0] + "|" + parts[1];

                    if (seenApps[key]) {
                        return;
                    }

                    seenApps[key] = true;

                    const icon = parts[2] || "";

                    if (icon) {
                        Quickshell.iconPath(icon, "application-x-executable");
                    }

                    allApps = allApps.concat([
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
        seenApps = ({});
        appListProc.running = true;
    }
}
