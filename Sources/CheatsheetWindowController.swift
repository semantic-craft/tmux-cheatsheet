import AppKit
import SwiftUI

/// Hosts the cheatsheet in an AppKit-managed window so a global hotkey can
/// summon, raise, or hide it from anywhere — a SwiftUI `Window` scene can only
/// be opened from inside the scene graph, which the hotkey handler is not.
/// Mirrors mac-tmux-kit's DashboardWindowController.
@MainActor
final class CheatsheetWindowController: NSObject, NSWindowDelegate {
    private var window: NSWindow?

    /// Hide if the window is already frontmost; otherwise show + raise it.
    func toggle() {
        if let window, window.isVisible, window.isKeyWindow {
            window.orderOut(nil)
        } else {
            show()
        }
    }

    func show() {
        if window == nil { window = makeWindow() }
        NSApp.activate()
        window?.makeKeyAndOrderFront(nil)
    }

    private func makeWindow() -> NSWindow {
        let w = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 460, height: 560),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        w.title = "tmux Cheatsheet"
        w.isReleasedWhenClosed = false
        w.minSize = NSSize(width: 440, height: 520)
        w.center()
        w.setFrameAutosaveName("TmuxCheatsheetWindow")
        w.contentViewController = NSHostingController(rootView: CheatsheetWindowView())
        w.delegate = self
        return w
    }
}
