# VLC Reloaded features

## On-device captions

**Goal:** generate subtitles for a video without sending audio anywhere.

**How:** `Sources/Playback/Reloaded/OnDeviceCaptionService.swift` uses Apple's
`SpeechAnalyzer` + `SpeechTranscriber` (iOS 26+). The first use downloads the
language model; after that it works offline.

A note on naming: there is no public "Siri AI" API for apps. Apple's supported
on-device speech-to-text is the Speech framework used here, which is the same
technology family behind system dictation.

**Done:** transcription engine, SRT writer (`CaptionSRT.swift`).

**Not done:**
* A UI entry point (e.g. a "Generate captions" button in the player's subtitle menu) that calls `generateSubtitles(for:)` and then adds the `.srt` via `VLCPlaybackService`.
* Formats AVFoundation can't read (MKV, AVI, ...): needs audio extracted from libvlc.
* Unit tests for `CaptionSRT`.

## Liquid Glass

Building with the iOS 26 SDK gives system bars, sheets and buttons Liquid Glass
automatically. `ReloadedGlassView` (`Sources/Playback/Reloaded/ReloadedGlass.swift`)
is for custom floating controls; it falls back to a blur before iOS 26.

**Not done:** actually using it in the player controls and mini player, and checking
legibility of VLC's custom themed screens.

## Duo support

"iPhone Duo" isn't a product I could match to an Apple device. Possibilities:
a dual-pane layout for large screens/foldables, using two displays (external
display support already exists in `VLCExternalDisplayController`), or something
else. This is intentionally not built until the intent is confirmed.
