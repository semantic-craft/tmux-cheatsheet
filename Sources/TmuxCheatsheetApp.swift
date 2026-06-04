import SwiftUI

/// Standalone, sandboxed tmux cheatsheet — a pure reference app (no tmux control,
/// no Accessibility, no external processes), so it is Mac App Store-eligible.
@main
struct TmuxCheatsheetApp: App {
    var body: some Scene {
        WindowGroup {
            CheatsheetWindowView()
        }
        .windowResizability(.contentMinSize)
    }
}
