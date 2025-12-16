![Header](assets/header.svg)

<div align="center">

[![Latest Release](https://img.shields.io/github/v/release/csmit195/rm-plex-activity-skin?style=flat-square&color=e5a00d)](https://github.com/csmit195/rm-plex-activity-skin/releases)
[![Downloads](https://img.shields.io/github/downloads/csmit195/rm-plex-activity-skin/total?style=flat-square&color=blueviolet)](https://github.com/csmit195/rm-plex-activity-skin/releases)
[![Rainmeter](https://img.shields.io/badge/Rainmeter-4.5%2B-blue?style=flat-square)](https://www.rainmeter.net/)

**Surface real-time Plex playback activity directly on your desktop.**

</div>

## 📖 Overview
**Plex Activity** is a lightweight, responsive Rainmeter skin that monitors your Tautulli (formerly PlexPy) server. It displays active sessions, stream details, transcoding status, and progress bars in a clean, unobtrusive list. 

Whether you want a solid background or a **fully transparent** overlay, this skin adapts to your desktop aesthetic.

## ✨ Features
*   **Real-time Monitoring:** Displays up to 5 concurrent sessions.
*   **Smart Resizing:** Background automatically expands or contracts based on active streams; collapses to a "No one is watching" state when idle.
*   **Visual Status:** Color-coded indicators for Play, Pause, and Transcoding.
*   **Rich Tooltips:** Hover over any row to see full title, elapsed time, player device, IP address, and quality decisions (Direct Play vs Transcode).
*   **Highly Configurable:** Full support for custom fonts, sizes, and **RGBA transparency**.

## 🖼️ Previews

| Default Dark | Transparent Mode |
| :---: | :---: |
| ![Default Preview](previews/default.png) | *Enable RGBA support to remove the background entirely.* |

## 📦 Requirements
1.  **Rainmeter:** Current stable version recommended.
2.  **Tautulli:** You must have Tautulli installed and running.
    *   *Note: This skin does not communicate directly with Plex; it uses the Tautulli API.*

## 🚀 Installation

1.  Download the latest `.rmskin` package from the [**Releases Page**](https://github.com/csmit195/rm-plex-activity-skin/releases/latest).
2.  Double-click `plex-activity.rmskin` to install it via the Rainmeter Skin Installer.
3.  Once installed, load the skin: `Skins` → `Tautulli` → `PlexActivity.ini`.

## ⚙️ Configuration & Setup

To make the skin work, you need to link it to your server.

1.  Right-click the skin and select **"Edit skin"** (or open `@Resources/variables.inc`).
2.  Locate the `[Variables]` section.

### 1. Connection (Required)
You must set these for the skin to function:
```ini
PlexPyAddress=http://192.168.1.50:8181
; Your Tautulli base URL (local IP or domain)

APIKey=YOUR_TAUTULLI_API_KEY
; Found in Tautulli Settings -> Web Interface -> API Key