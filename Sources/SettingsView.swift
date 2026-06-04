import SwiftUI
import KeyboardShortcuts

/// Preferences (Cmd+,): rebind the global summon shortcut. Kept to a single
/// grouped Form, matching mac-tmux-kit's settings styling.
struct SettingsView: View {
    var body: some View {
        Form {
            Section("Global shortcut") {
                KeyboardShortcuts.Recorder("Show cheatsheet", name: .toggleCheatsheet)
            }
            Section {
                Text("Press this combination from any app to show or hide the cheatsheet. Default: ⌘⌃⌥⇧C. Click the field and record a new one to change it.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .frame(width: 420, height: 220)
    }
}
