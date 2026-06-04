# Tmux Cheatsheet

A tiny, native macOS app: a searchable, click-to-copy reference of tmux
shortcuts. Pure reference — it does **not** control tmux, run any processes, or
touch other apps — so it's fully **sandboxed** and **Mac App Store-eligible**.

It is a standalone companion to [Tmux Kit](https://github.com/semantic-craft/mac-tmux-kit)
(the full GUI manager) but shares no code or data with it — the two are
independent projects.

## Build

```sh
# prerequisites: Xcode, XcodeGen (brew install xcodegen)
xcodegen generate
open TmuxCheatsheet.xcodeproj      # or: xcodebuild -scheme TmuxCheatsheet build
```

## App Store

Sandboxed and submission-ready. Shipping it requires an Apple Developer Program
membership and an App Store Connect record (created under your own Apple account).

## License

MIT.
