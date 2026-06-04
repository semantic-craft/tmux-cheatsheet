import SwiftUI
import AppKit

/// Windowed, searchable tmux cheatsheet. Click a row to copy its key sequence.
struct CheatsheetWindowView: View {
    @State private var query = ""

    private var filtered: [CheatItem] {
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else { return Cheatsheet.items }
        return Cheatsheet.items.filter {
            $0.title.lowercased().contains(q)
                || $0.keys.lowercased().contains(q)
                || $0.section.lowercased().contains(q)
                || $0.note.lowercased().contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(Cheatsheet.sections, id: \.self) { section in
                    let rows = filtered.filter { $0.section == section }
                    if !rows.isEmpty {
                        Section(section) {
                            ForEach(rows) { CheatsheetRow(item: $0) }
                        }
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("tmux Cheatsheet")
            .searchable(text: $query, prompt: "Filter shortcuts")
        }
        .frame(minWidth: 440, minHeight: 520)
    }
}

private struct CheatsheetRow: View {
    let item: CheatItem
    @State private var copied = false

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title).font(.system(size: 13))
                if !item.note.isEmpty {
                    Text(item.note).font(.system(size: 11)).foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 12)
            Text(copied ? "Copied" : item.keys)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(copied ? .green : .secondary)
                .textSelection(.enabled)
        }
        .contentShape(Rectangle())
        .onTapGesture { copy() }
        .help("Click to copy: \(item.keys)")
    }

    private func copy() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(item.keys, forType: .string)
        copied = true
        Task {
            try? await Task.sleep(nanoseconds: 900_000_000)
            copied = false
        }
    }
}
