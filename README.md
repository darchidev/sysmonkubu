# SysMonKubu

**Real-time system monitor widget for KDE Plasma 6**

<p align="center">
  <img src="preview.png" alt="SysMonKubu Preview" width="400"/>
</p>

SysMonKubu is a lightweight Plasma applet that displays real-time system resource usage directly in your panel. It shows CPU, GPU, RAM, and disk usage at a glance with color-coded bars and labels.

## Features

- **Real-time monitoring** - Updates every 2 seconds
- **Multi-GPU support** - Works with NVIDIA, AMD, and Intel graphics
- **Color-coded display** - Green (CPU), Pink (GPU), Blue (RAM), Orange (Disk)
- **Compact design** - Minimal footprint on your panel
- **Open source** - Free and transparent

## Requirements

- KDE Plasma 6.x
- Linux with `/proc` filesystem
- Optional: `nvidia-smi` for NVIDIA GPU monitoring

## Installation

### From KDE Store (recommended)

1. Open **System Settings** → **Plasma Widgets**
2. Search for "SysMonKubu"
3. Click **Install**

### Manual Installation

```bash
# Copy to local plasmoids directory
cp -r SysMonKubu ~/.local/share/plasma/plasmoids/

# Rebuild Plasma cache
kbuildsycoca6

# Restart Plasma (optional)
systemctl --user restart plasma-plasmashell
```

### Add to Panel

1. Right-click on your panel
2. Select **Add Widgets**
3. Search for "SysMonKubu"
4. Drag it to your panel

## Usage

The widget displays four metrics in your panel:

| Color | Metric | Description |
|-------|--------|-------------|
| 🟢 Green | CPU | Processor usage percentage |
| 🩷 Pink | GPU | Graphics card usage percentage |
| 🔵 Blue | RAM | Memory usage percentage |
| 🟠 Orange | DISK | Root partition usage |

Click on the widget to see more details in the popup.

## Building from Source

```bash
# Create package archive
tar -czf SysMonKubu.plasmoid --transform 's,^\./,,' .

# Install locally
kpackagetool6 --type Plasma/Applet --install SysMonKubu.plasmoid
```

## Supported GPUs

- **NVIDIA** - Uses `nvidia-smi`
- **AMD** - Reads from `/sys/class/drm/card*/device/gpu_busy_percent`
- **Intel** - Reads from `/sys/class/drm/card*/device/gpu_busy_percent`
- **Others** - Displays 0%

## Configuration

Edit `contents/scripts/monitor.sh` to customize:
- Update interval (default: 2 seconds)
- Disk partition to monitor
- Additional metrics

## Troubleshooting

### Widget not appearing
```bash
kbuildsycoca6
systemctl --user restart plasma-plasmashell
```

### GPU shows 0%
- Ensure `nvidia-smi` is installed for NVIDIA cards
- AMD/Intel GPUs require kernel support for `gpu_busy_percent`

### Permission errors
The script reads system files that require read permissions. Most users won't encounter issues.

## License

**GPLv3** - See LICENSE file for details.

---

Made with ❤️ by **Dario Chiapperini**

- Website: [dariochiapperini.dev](https://dariochiapperini.dev)
- GitHub: [@darchidev](https://github.com/darchidev)
- KDE Store: [SysMonKubu](https://store.kde.org)


<p align="center">
  <sub>SysMonKubu © 2026 Dario Chiapperini</sub>
</p>