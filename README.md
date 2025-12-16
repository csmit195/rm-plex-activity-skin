![Header](assets/header.svg)

<div align="center">

[![Latest Release](https://img.shields.io/github/v/release/csmit195/rm-plex-activity-skin?style=flat-square&color=e5a00d)](https://github.com/csmit195/rm-plex-activity-skin/releases)
[![Downloads](https://img.shields.io/github/downloads/csmit195/rm-plex-activity-skin/total?style=flat-square&color=blueviolet)](https://github.com/csmit195/rm-plex-activity-skin/releases)
[![Rainmeter](https://img.shields.io/badge/Rainmeter-4.5%2B-blue?style=flat-square)](https://www.rainmeter.net/)

**Surface real-time Plex playback activity directly on your desktop.**

</div>

## 📖 Overview
**Plex Activity** is a lightweight Rainmeter skin that monitors your Tautulli server. It displays active sessions, stream details, transcoding status, and progress bars.

## 🖼️ Preview
![Preview](previews/default.png)

## 🚀 Installation
1.  Download the latest `.rmskin` from the [**Releases Page**](https://github.com/csmit195/rm-plex-activity-skin/releases/latest).
2.  Double-click to install.
3.  Load `Skins` → `Tautulli` → `PlexActivity.ini`.

## ⚙️ Configuration
Right-click the skin and select **"Edit skin"** (or open `@Resources/variables.inc`).

### 1. Connection (Required)
```ini
PlexPyAddress=http://192.168.1.199:8181
; Your Tautulli IP and Port

APIKey=8449903058c14827aa54ad4af9d06579
; Found in Tautulli Settings -> Web Interface -> API Key
```

### 2. Background Color & Transparency (RGBA)
You can change the background color using **RGB** (Solid) or **RGBA** (Transparent).

The format is `Red, Green, Blue, Alpha`.
*   **Red/Green/Blue:** 0-255 (The color).
*   **Alpha:** 0-255 (The visibility).
    *   `255` = Solid (No transparency).
    *   `0` = Invisible (Fully transparent).

**Examples:**
```ini
; Default: Dark Grey with 50% transparency
BgColor=25,25,25,125

; Solid Black (No transparency)
BgColor=0,0,0,255

; Fully Invisible Background (Floating text)
BgColor=0,0,0,1
```

### 3. Other Settings
```ini
; Update speed (2 = ~1 second, 6 = ~3 seconds)
RefreshRate=2

; Text Colors
DefaultFontColor=255,255,255
ColorPlay=100,220,100,255
ColorPause=220,220,100,255
ColorTranscode=255,150,0,255
```

## ❓ Troubleshooting
*   **"No one is watching":** Check your API Key and ensure Tautulli is running.
*   **Background is too dark/light:** Adjust the 4th number in `BgColor` (lower number = more transparent).
*   **Changes not showing:** You must **Refresh** the skin in Rainmeter after saving the file.

---
<div align="center">
  Licensed under Creative Commons Attribution-Non-Commercial-Share Alike 3.0
</div>