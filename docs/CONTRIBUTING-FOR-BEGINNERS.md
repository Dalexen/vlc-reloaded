# Your first change

1. Fork and clone the repo; run `pod install`; open `VLC.xcworkspace`.
2. Pick the **VLC-iOS-no-watch** scheme and an iPhone simulator, press **Run**.
3. Find the code: use Xcode's search (⇧⌘F). For example, search a button's visible text.
4. Make a small change, run again, see it work.
5. Create a branch (`git checkout -b my-change`), commit, push, open a pull request.
6. The **Build unsigned IPA** workflow will show whether it still builds.

## Tips

* Objective-C files come in pairs (`.h` header + `.m` implementation).
* New files: right-click the folder in Xcode → *New File*, and tick both iOS targets.
* Read [ARCHITECTURE.md](ARCHITECTURE.md) first to know which folder to look in.
* Stuck? Search the code for similar features and copy their pattern.
