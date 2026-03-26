//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import SwiftUI

@MainActor @Observable
final class DeviceSupportViewModel {
    var entries: [DeviceSupportEntry] = []
    var folderPath: String = defaultPath
    var errorMessage: String?
    var isLoading = false

    static let defaultPath: String = {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Developer/Xcode/iOS DeviceSupport")
            .path(percentEncoded: false)
    }()

    func loadEntries() {
        isLoading = true
        errorMessage = nil

        let fileManager = FileManager.default
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folderPath)
            entries = contents
                .sorted()
                .compactMap { DeviceSupportEntry(folderName: $0) }
        } catch {
            errorMessage = error.localizedDescription
            entries = []
        }

        isLoading = false
    }

    func trashEntries(withIDs ids: Set<DeviceSupportEntry.ID>) throws {
        let folderURL = URL(fileURLWithPath: folderPath)
        let entriesToTrash = entries.filter { ids.contains($0.id) }

        for entry in entriesToTrash {
            let url = folderURL.appendingPathComponent(entry.folderName)
            try FileManager.default.trashItem(at: url, resultingItemURL: nil)
        }

        entries.removeAll { ids.contains($0.id) }
    }

    func chooseFolderViaOpenPanel() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.directoryURL = URL(fileURLWithPath: folderPath)
        panel.message = "Select the DeviceSupport folder"

        if panel.runModal() == .OK, let url = panel.url {
            folderPath = url.path(percentEncoded: false)
            loadEntries()
        }
    }
}
