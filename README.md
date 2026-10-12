# VLC Reloaded

A fork of [VLC for iOS / iPadOS](https://code.videolan.org/videolan/vlc-ios) with a
modern look and smarter playback, plus documentation written for people who are
new to the codebase.

| Feature | Status |
|---|---|
| Unsigned `.ipa` from GitHub Actions | ✅ ready ([how](#get-an-unsigned-ipa)) |
| On-device AI captions (Apple Speech, iOS 26+) | 🧪 engine added, not yet wired into the player UI ([details](docs/FEATURES.md#on-device-captions)) |
| Liquid Glass UI (iOS 26) | 🧪 reusable component added; system bars get it automatically with the iOS 26 SDK ([details](docs/FEATURES.md#liquid-glass)) |
| Foldable / "Duo" layout | ❓ not started, needs clarification ([details](docs/FEATURES.md#duo-support)) |

> **Honest status:** none of the Swift changes have been compiled yet (they were
> written without Xcode). The first CI run is the real test; expect to fix a
> compile error or two. See [docs/FEATURES.md](docs/FEATURES.md).

## Get an unsigned IPA

1. Open the **Actions** tab of this repository.
2. Choose **Build unsigned IPA** → **Run workflow**.
3. When it finishes (about 20-40 min), download `VLC-Reloaded-unsigned-ipa`
   from the run's **Artifacts**.
4. Sign and install it with your tool of choice (Sideloadly, AltStore, TrollStore, etc.).

Pushing a tag like `v0.1.0` also attaches the IPA to a GitHub Release.

## Build it yourself

Requirements: a Mac, **Xcode 26+**, [CocoaPods](https://cocoapods.org).

```sh
git clone https://github.com/dalexen/vlc-reloaded.git
cd vlc-reloaded
pod install          # on Apple Silicon, if it fails: arch -x86_64 pod install
open VLC.xcworkspace # pick scheme "VLC-iOS-no-watch", then Run
```

## New here? Start with these

* [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md): a map of the folders and how playback works
* [docs/FEATURES.md](docs/FEATURES.md): what Reloaded adds and how each piece works
* [docs/CONTRIBUTING-FOR-BEGINNERS.md](docs/CONTRIBUTING-FOR-BEGINNERS.md): your first change, step by step
* [Documentation/CodingStyle.md](Documentation/CodingStyle.md): upstream code style

## Credits and license

Based on VLC for iOS by [VideoLAN](https://www.videolan.org). VLC Reloaded is an
unofficial fork, not affiliated with or endorsed by VideoLAN. Licensed under the
same terms as upstream; see [COPYING](COPYING).
