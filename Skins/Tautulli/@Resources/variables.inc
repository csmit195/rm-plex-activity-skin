[Variables]
; ------------------------------------------------------------------------
; CONNECTION
; ------------------------------------------------------------------------
PlexPyAddress=http://192.168.1.199:8181
APIKey=8449903058c14827aa54ad4af9d06579
; Number of skin update cycles to wait between API calls.
; Skin Update is 500ms, so 2 = ~1s, 6 = ~3s, 12 = ~6s, etc.
RefreshRate=2

; ------------------------------------------------------------------------
; VISUALS
; ------------------------------------------------------------------------
; Solid Background Color (Dark Grey)
BgColor=25,25,25

; ------------------------------------------------------------------------
; SIZING
; ------------------------------------------------------------------------
; Minimum height of the background (even if no one is playing)
MinHeight=80

; Maximum height before the list truncates. 
; Comment out or set extremely high (e.g., 2000) to disable.
; A standard row is roughly 65px. Header is 50px.
MaxHeight=500

; ------------------------------------------------------------------------
; FONTS & COLORS
; ------------------------------------------------------------------------
FontMain=Segoe UI
FontHeader=Segoe UI Semibold
DefaultFontColor=255,255,255
MaxTitleLength=40

ColorPlay=100,220,100,255
ColorPause=220,220,100,255
ColorTranscode=255,150,0,255

