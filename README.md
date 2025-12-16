![Preview](previews/default.png)

# Plex Activity (Rainmeter Skin)
A Rainmeter skin by `csmit195` that surfaces real-time Plex playback activity from your Tautulli/PlexPy server. Shows who is watching, what they are watching, stream quality, progress bars, and quick tooltips per session.

## Features
- Displays up to 5 concurrent Plex sessions with per-user rows.
- Shows stream counts with transcode indicator in the header.
- Per-row details: user name, truncated title/episode info, progress bar, and status-aware colors (play/pause/transcode).
- Tooltips include full title, time position, player, IP, and quality decision.
- Auto-resizes background height to fit the number of sessions; falls back to “No one is watching” state when empty.

## Download
- Latest release (`.rmskin`): [plex-activity-1-0-0.rmskin](https://github.com/csmit195/plex-activity/releases/latest/download/plex-activity-1-0-0.rmskin)

## Requirements
- Rainmeter (tested with current stable)
- Tautulli/PlexPy reachable over HTTP(S) with an API key
- No external plugins beyond Rainmeter built-ins:
  - WebParser (for Tautulli API calls)
  - Script / Lua (for parsing and meter updates)

## Installation
1) Download the `.rmskin` package from the link above.  
2) Double-click the package to install.  
3) Load the skin from Rainmeter: `Skins → Tautulli → PlexActivity.ini`.

## Configuration
Edit `@Resources/variables.inc` (or use Rainmeter’s “Edit skin”) and adjust:

Important:
- `PlexPyAddress` – Base URL to Tautulli/PlexPy (e.g., `http://server:8181`).
- `APIKey` – Your Tautulli API key.

Style:
- `RefreshRate` – Skin update cycles between API calls (skin updates every 500ms; `2 ≈ 1s`, `6 ≈ 3s`, `12 ≈ 6s`).
- `BgColor` – Background fill color `R,G,B`.
- Fonts/Colors:
  - `FontMain`, `FontHeader`, `DefaultFontColor`
  - `ColorPlay`, `ColorPause`, `ColorTranscode`
- `MaxTitleLength` – Max characters before truncating titles.

After editing, refresh the skin in Rainmeter.

### What the skin shows
- Header: total active streams and number transcoding.
- Rows (up to 5): user, title/episode, progress bar sized to percent complete.
- Tooltip on each row: full title, elapsed/total, player + IP, resolution + decision, and paused status.

## Troubleshooting
- No data / always “No one is watching”: confirm `PlexPyAddress` and `APIKey`, and that Tautulli is reachable from this machine.
- Wrong counts: ensure the Rainmeter update interval is not throttled and `RefreshRate` is reasonable (try `6`).
- Colors not updating: make sure you saved `variables.inc` and refreshed the skin.
- Progress bars overshoot: the Lua clamps values between 0–100; check Tautulli values if this persists.
- Tooltips missing: keep the hitbox meters visible; don’t hide the `Row*Hitbox` meters.

## Variables showcase
More examples will be added here to show alternative color/font/background setups so you can compare and copy settings quickly.

## Credits
- Skin, Lua parsing, and design: `csmit195`
- License: Creative Commons Attribution-Non-Commercial-Share Alike 3.0

