import KeyboardShortcuts

/// The user-rebindable global hotkey that summons the cheatsheet.
///
/// KeyboardShortcuts persists any override to UserDefaults and supplies the
/// `Recorder` view used in Settings. It registers a Carbon hotkey, so this works
/// inside the App Sandbox with no Accessibility grant — the app stays Mac App
/// Store-eligible. (Mirrors mac-tmux-kit's `.toggleDashboard` Hyper+D.)
extension KeyboardShortcuts.Name {
    /// Show / raise / hide the cheatsheet window. Default: Hyper+C (⌘⌃⌥⇧C).
    static let toggleCheatsheet = Self(
        "toggleCheatsheet",
        default: .init(.c, modifiers: [.command, .control, .option, .shift])
    )
}
