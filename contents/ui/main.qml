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

    readonly property string scriptPath: "/home/dario/.local/share/plasma/plasmoids/SysMonKubu/contents/scripts/monitor.sh"

    Plasma5Support.DataSource {
        id: execSource
        engine: "executable"
        connectedSources: []
        
        onNewData: function(source, data) {
            var out = data.stdout || data.output || data.result || "";
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

    Timer {
        interval: 500
        repeat: true
        running: true
        onTriggered: {
            execSource.connectSource("/bin/bash " + scriptPath);
        }
    }

    compactRepresentation: ColumnLayout {
        spacing: 0

        RowLayout {
            spacing: 1

            Rectangle {
                color: "#2ecc71"
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                Rectangle {
                    color: "#1e8449"
                    width: parent.width * cpuValue / 100
                    height: parent.height
                    anchors.left: parent.left
                }
                Text { text: cpuText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 }
            }
            Rectangle {
                color: "#e74c8c"
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                Rectangle {
                    color: "#922b21"
                    width: parent.width * gpuValue / 100
                    height: parent.height
                    anchors.left: parent.left
                }
                Text { text: gpuText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 }
            }
            Rectangle {
                color: "#3498db"
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                Rectangle {
                    color: "#154360"
                    width: parent.width * memValue / 100
                    height: parent.height
                    anchors.left: parent.left
                }
                Text { text: memText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 }
            }
            Rectangle {
                color: "#f39c12"
                Layout.fillHeight: true
                Layout.preferredWidth: 60
                Rectangle {
                    color: "#e67e22"
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
        implicitWidth: 300
        implicitHeight: 100
        Text { text: "SysMonKubu: " + cpuText; anchors.centerIn: parent }
    }
}