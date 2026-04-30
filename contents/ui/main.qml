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

    readonly property string scriptPath: "/home/dario/.local/share/plasma/plasmoids/SysMonKubu/contents/scripts/monitor.sh"

    Plasma5Support.DataSource {
        id: execSource
        engine: "executable"
        connectedSources: []
        
        onNewData: function(source, data) {
            var out = data.stdout || data.output || data.result || "";
            var parts = out.trim().split(" ");
            if (parts.length >= 4) {
                cpuText = parts[0] + "%";
                gpuText = parts[1] + "%";
                memText = parts[2] + "%";
                diskText = parts[3] + "%";
            }
        }
    }

    Timer {
        interval: 2000
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

            Rectangle { color: "#2ecc71"; Layout.fillHeight: true; Layout.preferredWidth: 60
                Text { text: cpuText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 } }
            Rectangle { color: "#e74c8c"; Layout.fillHeight: true; Layout.preferredWidth: 60
                Text { text: gpuText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 } }
            Rectangle { color: "#3498db"; Layout.fillHeight: true; Layout.preferredWidth: 60
                Text { text: memText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 } }
            Rectangle { color: "#f39c12"; Layout.fillHeight: true; Layout.preferredWidth: 60
                Text { text: diskText; anchors.centerIn: parent; color: "white"; font.bold: true; font.pixelSize: 11 } }
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