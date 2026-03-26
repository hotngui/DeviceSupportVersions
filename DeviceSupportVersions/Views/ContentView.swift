//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = DeviceSupportViewModel()
    @State private var selectedEntryIDs: Set<DeviceSupportEntry.ID> = []
    @State private var showingTrashConfirmation = false
    @State private var trashError: String?

    var body: some View {
        VStack(spacing: 0) {
            Group {
                if viewModel.isLoading {
                    ProgressView("Scanning...")
                } else if let error = viewModel.errorMessage {
                    ContentUnavailableView(
                        "Unable to Read Folder",
                        systemImage: "folder.badge.questionmark",
                        description: Text(error)
                    )
                } else if viewModel.entries.isEmpty {
                    ContentUnavailableView(
                        "No Device Support Found",
                        systemImage: "externaldrive",
                        description: Text("The folder contains no recognizable entries.")
                    )
                } else {
                    DeviceSupportTable(entries: viewModel.entries, selectedEntryIDs: $selectedEntryIDs)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Divider()

            HStack {
                if selectedEntryIDs.isEmpty {
                    Text("\(viewModel.entries.count) items")
                        .accessibilityIdentifier("StatusBarText")
                } else {
                    Text("\(selectedEntryIDs.count) of \(viewModel.entries.count) selected")
                        .accessibilityIdentifier("StatusBarText")
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .font(.callout)
            .foregroundStyle(.secondary)
            .background(.bar)
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.chooseFolderViaOpenPanel()
                } label: {
                    Label("Choose Folder", systemImage: "folder")
                }
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.loadEntries()
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                }
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    showingTrashConfirmation = true
                } label: {
                    Label("Move to Trash", systemImage: "trash")
                }
                .accessibilityIdentifier("TrashButton")
                .disabled(selectedEntryIDs.isEmpty)
            }
        }
        .confirmationDialog(
            "Move \(selectedEntryIDs.count) item\(selectedEntryIDs.count == 1 ? "" : "s") to Trash?",
            isPresented: $showingTrashConfirmation
        ) {
            Button("Move to Trash", role: .destructive) {
                do {
                    try viewModel.trashEntries(withIDs: selectedEntryIDs)
                    selectedEntryIDs.removeAll()
                } catch {
                    trashError = error.localizedDescription
                }
            }
        } message: {
            let names = viewModel.entries
                .filter { selectedEntryIDs.contains($0.id) }
                .map(\.folderName)
                .sorted()
                .joined(separator: "\n")
            Text("These folders will be moved to the Trash and can be recovered from there:\n\n\(names)")
        }
        .alert("Failed to Move to Trash", isPresented: Binding(
            get: { trashError != nil },
            set: { if !$0 { trashError = nil } }
        )) {
            Button("OK") { trashError = nil }
        } message: {
            Text(trashError ?? "")
        }
        .navigationTitle("Device Support Versions")
        .navigationSubtitle("\(viewModel.entries.count) entries — \(viewModel.folderPath)")
        .onAppear {
            viewModel.loadEntries()
        }
    }
}

#Preview {
    ContentView()
}
