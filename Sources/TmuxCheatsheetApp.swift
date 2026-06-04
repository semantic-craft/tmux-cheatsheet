import SwiftUI
import KeyboardShortcuts

/// Standalone, sandboxed tmux cheatsheet — a pure reference app (no tmux control,
/// no Accessibility, no external processes), so it is Mac App Store-eligible.
///
/// The cheatsheet lives in an AppKit window (see `CheatsheetWindowController`) so
/// a global hotkey can summon it from any app. The only SwiftUI scene is
/// `Settings`, which gives us the standard Cmd+, preferences window.
@main
struct TmuxCheatsheetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

/// Owns the cheatsheet window and the global hotkey. Created once at launch.
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let windowController = CheatsheetWindowController()

    func applicationDidFinishLaunching(_ notification: Notification) {
        windowController.show()
        KeyboardShortcuts.onKeyDown(for: .toggleCheatsheet) { [weak windowController] in
            windowController?.toggle()
        }
    }

    /// Re-show the window when the app is reactivated from the Dock after the
    /// user closed it (the app stays resident so the hotkey keeps working).
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag { windowController.show() }
        return true
    }
}
