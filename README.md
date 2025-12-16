![Plex Activity](assets/header.svg)

[![Latest Release](https://img.shields.io/github/v/release/csmit195/rm-plex-activity-skin?style=flat-square&color=e5a00d)](https://github.com/csmit195/rm-plex-activity-skin/releases)
[![Downloads](https://img.shields.io/github/downloads/csmit195/rm-plex-activity-skin/total?style=flat-square&color=blueviolet)](https://github.com/csmit195/rm-plex-activity-skin/releases)
[![Rainmeter](https://img.shields.io/badge/Rainmeter-4.5%2B-blue?style=flat-square)](https://www.rainmeter.net/)

## Overview
**Plex Activity** is a lightweight Rainmeter skin that monitors your Tautulli server. It surfaces real-time playback activity, including user details, stream quality, transcoding status, and progress bars.

## Preview
![Preview](previews/default.png)

## Installation
1. Download the latest `.rmskin` package from the [Releases Page](https://github.com/csmit195/rm-plex-activity-skin/releases/latest).
2. Double-click the file to install it with Rainmeter.
3. Load the skin: `Skins` -> `Tautulli` -> `PlexActivity.ini`.

## Configuration
To set up the skin, right-click it and select **Edit skin** (or open `@Resources/variables.inc`).

### 1. Connection (Required)
You must set your Tautulli address and API key for the skin to work.

```ini
PlexPyAddress=http://192.168.1.199:8181
; Your Tautulli IP and Port

APIKey=8449903058c14827aa54ad4af9d06579
; Found in Tautulli Settings -> Web Interface -> API Key
```

### 2. Background Color & Transparency (RGBA)
You can control the background color and opacity using the `BgColor` variable.
The format is **Red, Green, Blue, Alpha**.

*   **R, G, B**: The color values (0-255).
*   **Alpha**: The opacity level (0-255).
    *   `255` = Solid color.
    *   `0` = Fully transparent (invisible).

**Examples:**

```ini
; Default (Dark Grey, Semi-Transparent)
BgColor=25,25,25,125

; Solid Black (No transparency)
BgColor=0,0,0,255

; Fully Transparent (Invisible background, text only)
BgColor=0,0,0,1
```

### 3. Other Settings

```ini
; Update speed. 2 = ~1 second, 6 = ~3 seconds (Recommended)
RefreshRate=2

; Font and Color settings
FontMain=Segoe UI
DefaultFontColor=255,255,255
ColorPlay=100,220,100,255
ColorPause=220,220,100,255
ColorTranscode=255,150,0,255
```

## Troubleshooting
*   **"No one is watching"**: Verify `PlexPyAddress` is reachable and `APIKey` is correct.
*   **Background opacity**: If the background is too dark or too light, adjust the 4th number in `BgColor`.
*   **Skin not updating**: Ensure you save the `variables.inc` file and right-click -> **Refresh** the skin in Rainmeter.

## Credits
*   **Skin & Code**: csmit195
*   **Backend Data**: Powered by Tautulli

Licensed under Creative Commons Attribution-Non-Commercial-Share Alike 3.0