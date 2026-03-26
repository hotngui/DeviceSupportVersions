//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import SwiftUI

struct DeviceSupportTable: View {
    var entries: [DeviceSupportEntry]

    @State private var sortOrder: [KeyPathComparator<DeviceSupportEntry>] = [
        KeyPathComparator(\.folderName),
        KeyPathComparator(\.marketingName),
        KeyPathComparator(\.friendlyOSVersion),
    ]
    @Binding var selectedEntryIDs: Set<DeviceSupportEntry.ID>

    private var sortedEntries: [DeviceSupportEntry] {
        entries.sorted(using: sortOrder)
    }

    var body: some View {
        Table(sortedEntries, selection: $selectedEntryIDs, sortOrder: $sortOrder) {
            TableColumn("Folder Name", value: \.folderName) { entry in
                Text(entry.folderName)
                    .font(.body.monospaced())
            }
            TableColumn("Device", value: \.marketingName)
            TableColumn("OS Version", value: \.friendlyOSVersion)
            TableColumn("Build", value: \.buildNumber) { entry in
                Text(entry.buildNumber)
                    .font(.body.monospaced())
            }
        }
        .accessibilityIdentifier("DeviceSupportTable")
    }
}

#Preview {
    DeviceSupportTable(entries: [
        DeviceSupportEntry(folderName: "iPhone17,2 26.4 (23E246)")!,
        DeviceSupportEntry(folderName: "iPad16,1 18.4.1 (22E252)")!,
        DeviceSupportEntry(folderName: "iPhone10,4 16.5.1 (20F75)")!,
    ], selectedEntryIDs: .constant([]))
    .frame(width: 900, height: 400)
}
