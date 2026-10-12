# Architecture: a map for newcomers

VLC for iOS is a mix of Objective-C and Swift. The video/audio engine is
**VLCKit** (a wrapper around libvlc), pulled in with CocoaPods.

## Folder map (`Sources/`)

| Folder | What lives there |
|---|---|
| `App/` | App delegate, startup, scene setup |
| `Playback/` | Everything about playing media: `Control/VLCPlaybackService` (the core player controller), `Player/` (video and audio UIs), `Queue/`, `Subtitles Downloading/` |
| `Playback/Reloaded/` | **New in Reloaded**: captions engine and Liquid Glass view |
| `Media Library/` | The library tabs (videos, music, collections) on top of MediaLibraryKit |
| `Network/`, `Cloud/`, `WiFi Sharing/` | SMB/FTP/UPnP browsing, Dropbox/Drive/OneDrive/Box, upload over Wi-Fi |
| `Settings/` | Settings screens |
| `UI Elements/` | Shared theme (`PresentationTheme`) and reusable controls |
| `CarPlay/`, `TopShelf/`, `Extensions/` | CarPlay, tvOS, share/widget extensions |

## Targets and schemes

* `VLC-iOS`: iPhone + iPad app **with** the Apple Watch app
* `VLC-iOS-no-watch`: same app without the watch app (what our CI builds)
* `VLC-tvOS`, `VLC-visionOS`, `VLC-watchOS`: other platforms

## How playback flows

1. A UI (library cell, network browser) asks `VLCPlaybackService` to play a media item.
2. `VLCPlaybackService` configures a `VLCMediaPlayer` from VLCKit and drives it.
3. `PlayerViewController` and the video/audio player views observe the service and render controls.
4. Subtitles are loaded by VLCKit; external `.srt` files next to the media are picked up.

## On-device captions

`OnDeviceCaptionService` reads a media file, runs Apple's `SpeechTranscriber`
on the device (iOS 26+), and writes a `.srt` file next to the media using
`CaptionSRT`. That file is a normal external subtitle, so the existing subtitle
code can load it. The service is **not called from the UI yet**; see
[FEATURES.md](FEATURES.md#on-device-captions).

## Build system notes

* Dependencies: `Podfile` / `Podfile.lock`. Always open `VLC.xcworkspace`, not the `.xcodeproj`.
* New Swift files must be added to the Xcode project and to both iOS targets' *Compile Sources*.
* CI: `.github/workflows/build-unsigned-ipa.yml`.
