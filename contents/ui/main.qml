import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support 2.0 as Plasma5Support

PlasmoidItem {
    id: root

    property string cpuText: "0%"
    property string gpuText: "0%"
    property string memText: "0%"
    property string diskText: "0%"
    property int cpuValue: 0
    property int gpuValue: 0
    property int memValue: 0
    property int diskValue: 0

    property string cpuColor: plasmoid.configuration.cpuColor || "#2ecc71"
    property string gpuColor: plasmoid.configuration.gpuColor || "#e74c8c"
    property string memColor: plasmoid.configuration.memColor || "#3498db"
    property string diskColor: plasmoid.configuration.diskColor || "#f39c12"

    function darkenColor(hex) {
        var r = parseInt(hex.slice(1,3), 16);
        var g = parseInt(hex.slice(3,5), 16);
        var b = parseInt(hex.slice(5,7), 16);
        r = Math.max(0, Math.floor(r * 0.6));
        g = Math.max(0, Math.floor(g * 0.6));
        b = Math.max(0, Math.floor(b * 0.6));
        return "#" + r.toString(16).padStart(2,'0') + g.toString(16).padStart(2,'0') + b.toString(16).padStart(2,'0');
    }

    readonly property string cpuDark: darkenColor(cpuColor)
    readonly property string gpuDark: darkenColor(gpuColor)
    readonly property string memDark: darkenColor(memColor)
    readonly property string diskDark: darkenColor(diskColor)

    readonly property string scriptPath: "/home/dario/.local/share/plasma/plasmoids/SysMonKubu/contents/scripts/monitor.sh"
    readonly property string command: "/bin/bash " + scriptPath

    Plasma5Support.DataSource {
        id: execSource
        engine: "executable"
        connectedSources: [command]
        interval: 500

        onNewData: function(source, data) {
            var out = data["stdout"] || "";
            var parts = out.trim().split(" ");
            if (parts.length >= 4) {
                cpuValue = parseFloat(parts[0]) || 0;
                gpuValue = parseFloat(parts[1]) || 0;
                memValue = parseFloat(parts[2]) || 0;
                diskValue = parseFloat(parts[3]) || 0;
                cpuText = cpuValue.toFixed(1) + "%";
                gpuText = gpuValue.toFixed(1) + "%";
                memText = memValue.toFixed(1) + "%";
                diskText = diskValue.toFixed(1) + "%";
            }
        }
    }

    compactRepresentation: ColumnLayout {
        spacing: 0

        RowLayout {
            spacing: 1

            Rectangle {
                color: cpuColor
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                Rectangle {
                    color: cpuDark
                    width: parent.width * cpuValue / 100
                    height: parent.height
                    anchors.left: parent.left
                }
                Text { text: cpuText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 }
            }
            Rectangle {
                color: gpuColor
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                Rectangle {
                    color: gpuDark
                    width: parent.width * gpuValue / 100
                    height: parent.height
                    anchors.left: parent.left
                }
                Text { text: gpuText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 }
            }
            Rectangle {
                color: memColor
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                Rectangle {
                    color: memDark
                    width: parent.width * memValue / 100
                    height: parent.height
                    anchors.left: parent.left
                }
                Text { text: memText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 }
            }
            Rectangle {
                color: diskColor
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                Rectangle {
                    color: diskDark
                    width: parent.width * diskValue / 100
                    height: parent.height
                    anchors.left: parent.left
                }
                Text { text: diskText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 }
            }
        }

        RowLayout {
            spacing: 1

            Rectangle { color: "transparent"; Layout.fillHeight: true; Layout.preferredWidth: 60
                Text { text: "CPU"; anchors.centerIn: parent; color: "white"; font.pixelSize: 9 } }
            Rectangle { color: "transparent"; Layout.fillHeight: true; Layout.preferredWidth: 60
                Text { text: "GPU"; anchors.centerIn: parent; color: "white"; font.pixelSize: 9 } }
            Rectangle { color: "transparent"; Layout.fillHeight: true; Layout.preferredWidth: 60
                Text { text: "RAM"; anchors.centerIn: parent; color: "white"; font.pixelSize: 9 } }
            Rectangle { color: "transparent"; Layout.fillHeight: true; Layout.preferredWidth: 60
                Text { text: "DISK"; anchors.centerIn: parent; color: "white"; font.pixelSize: 9 } }
        }
    }

    fullRepresentation: Item {
        implicitWidth: 260
        implicitHeight: 200

        Column {
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: "Impostazioni Colori"
                font.bold: true
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                spacing: 8
                Rectangle { width: 20; height: 20; color: cpuColor; radius: 3 }
                TextInput {
                    text: cpuColor
                    color: "white"
                    onAccepted: plasmoid.configuration.cpuColor = text
                    maximumLength: 7
                    width: 80
                }
            }

            Row {
                spacing: 8
                Rectangle { width: 20; height: 20; color: gpuColor; radius: 3 }
                TextInput {
                    text: gpuColor
                    color: "white"
                    onAccepted: plasmoid.configuration.gpuColor = text
                    maximumLength: 7
                    width: 80
                }
            }

            Row {
                spacing: 8
                Rectangle { width: 20; height: 20; color: memColor; radius: 3 }
                TextInput {
                    text: memColor
                    color: "white"
                    onAccepted: plasmoid.configuration.memColor = text
                    maximumLength: 7
                    width: 80
                }
            }

            Row {
                spacing: 8
                Rectangle { width: 20; height: 20; color: diskColor; radius: 3 }
                TextInput {
                    text: diskColor
                    color: "white"
                    onAccepted: plasmoid.configuration.diskColor = text
                    maximumLength: 7
                    width: 80
                }
            }

            Text {
                text: "Esempio: #2ecc71"
                font.pixelSize: 10
                color: "#888"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
