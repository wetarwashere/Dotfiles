import QtQuick
import Quickshell
import Quickshell.Io
import "."

Scope {
    EssentialsWidget {}
    ProfileWidget {}
    PlayerWidget {}
    VisualizerWidget {}
    AppLauncher {}
    ControllerWidget {}

    Connections {
        target: Shared

        function onRequestBrightnessDebounce() {
            brightnessSetterDebounce.restart();
        }

        function onRequestMusicVolumeDebounce() {
            musicVolumeSetterDebounce.restart();
        }
    }

    Process {
        command: ["sh", "-c", "udevadm monitor --subsystem-match=backlight --udev"]
        running: true
        stdout: SplitParser {
            onRead: brigthnessProc.running = true
        }
    }

    Process {
        id: brigthnessProc
        command: ["sh", "-c", "brightnessctl -m"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                Shared.brightness = this.text.split(",")[3].replace("%", "");
            }
        }
    }

    Process {
        id: musicVolumeProc
        command: ["sh", "-c", "playerctl -p spotify volume --follow 2>/dev/null"]
        running: true
        onExited: {
            Shared.musicVolume = 0;
            playerVolumeDebounce.start();
        }
        stdout: SplitParser {
            onRead: data => {
                const value = parseFloat(data.trim());

                if (!isNaN(value)) {
                    Shared.musicVolume = value;
                }
            }
        }
    }

    Process {
        id: usernameProc
        command: ["bash", "-c", "whoami"]
        running: true
        stdout: SplitParser {
            onRead: data => Shared.username = data.trim().charAt(0).toUpperCase() + data.trim().slice(1)
        }
    }

    Process {
        id: distroProc
        command: ["bash", "-c", "grep -oP '(?<=^PRETTY_NAME=\").*(?=\")' /etc/os-release"]
        running: true
        stdout: SplitParser {
            onRead: data => Shared.distro = data.trim()
        }
    }

    Process {
        id: windowManagerProc
        command: ["bash", "-c", "echo $XDG_CURRENT_DESKTOP"]
        running: true
        stdout: SplitParser {
            onRead: data => Shared.windowManager = data.trim().charAt(0).toUpperCase() + data.trim().slice(1)
        }
    }

    Process {
        id: cavaProc
        command: ["bash", "-c", 'cava -p "$HOME/.config/cava/quickshell.conf"']
        running: true
        stdout: SplitParser {
            onRead: data => {
                const vals = data.trim().split(";").filter(v => v.length > 0).map(Number);
                while (vals.length < 20)
                    vals.push(0);

                Shared.levels = vals.slice(0, 20).map(v => Math.max((v / 100) * 12, 2));
            }
        }
    }

    Process {
        id: playerProc
        property string result: ""

        command: ["bash", "-c", "playerctl -p spotify metadata --format '{{ title }}|{{ artist }}|{{ mpris:artUrl }}' --follow 2>/dev/null"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split("|");

                Shared.titleText = parts[0] || "Nothing";
                Shared.titleIcon = parts[0] ? " " : " ";
                Shared.artistText = parts[1] || "Nothing";
                Shared.artistIcon = parts[1] ? "󰀥 " : " ";
                Shared.artUrl = parts[2] || "";
            }
        }
    }

    Process {
        id: playerLoopProc
        command: ["bash", "-c", "playerctl -p spotify loop --follow 2>/dev/null"]
        running: true
        onExited: {
            Shared.loopIndex = 0;
            playerLoopDebounce.start();
        }
        stdout: SplitParser {
            onRead: data => {
                const status = data.trim();
                const index = Shared.loopStates.indexOf(status);

                if (index !== -1) {
                    Shared.loopIndex = index;
                }
            }
        }
    }

    Process {
        id: playerStatusProc
        property string result: ""

        command: ["bash", "-c", "playerctl -p spotify status --follow 2>/dev/null"]
        running: true
        onExited: {
            Shared.titleText = "Nothing";
            Shared.titleIcon = " ";
            Shared.artistText = "Nothing";
            Shared.artistIcon = " ";
            Shared.artUrl = "";
            Shared.isPlaying = false;
            playerStatusDebounce.start();
        }
        stdout: SplitParser {
            onRead: data => {
                const status = data.trim();

                if (status === "Playing") {
                    Shared.isPlaying = true;
                } else if (status === "Paused") {
                    Shared.isPlaying = false;
                } else if (status.length === 0 || status === "Stopped") {
                    Shared.titleText = "Nothing";
                    Shared.titleIcon = " ";
                    Shared.artistText = "Nothing";
                    Shared.artistIcon = " ";
                    Shared.artUrl = "";
                    Shared.isPlaying = false;
                }
            }
        }
    }

    Process {
        id: appListProc
        command: ["bash", "-c", "for f in /usr/share/applications/*.desktop $HOME/.local/share/applications/*.desktop; do " + "[ -f \"$f\" ] || continue; " + "n=$(grep -m1 '^Name=' \"$f\" | cut -d= -f2-); " + "e=$(grep -m1 '^Exec=' \"$f\" | cut -d= -f2- | sed 's/%[a-zA-Z]//g'); " + "i=$(grep -m1 '^Icon=' \"$f\" | cut -d= -f2-); " + "[ -n \"$n\" ] && [ -n \"$e\" ] && echo \"$n|$e|$i\"; " + "done"]
        running: true
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

    Process {
        id: brigthnessSetter
        command: ["brightnessctl", "set", "-q", Shared.brightness + "%"]
    }

    Process {
        id: musicVolumeSetter
        command: ["playerctl", "-p", "spotify", "volume", Shared.musicVolume.toString()]
    }

    Timer {
        id: brightnessSetterDebounce
        interval: 50
        repeat: false
        onTriggered: brigthnessSetter.running = true
    }

    Timer {
        id: musicVolumeSetterDebounce
        interval: 50
        repeat: false
        onTriggered: musicVolumeSetter.running = true
    }

    Timer {
        id: playerLoopDebounce
        interval: 1000
        onTriggered: playerLoopProc.running = true
    }

    Timer {
        id: playerVolumeDebounce
        interval: 1000
        onTriggered: musicVolumeProc.running = true
    }

    Timer {
        id: playerStatusDebounce
        interval: 1000
        onTriggered: playerStatusProc.running = true
    }
}
