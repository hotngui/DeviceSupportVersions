//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import Foundation

struct DeviceSupportEntry: Identifiable, Sendable {
    let id = UUID()
    let folderName: String
    let modelIdentifier: String
    let osVersion: String
    let buildNumber: String
    let marketingName: String
    let osPrefix: String

    var friendlyOSVersion: String {
        "\(osPrefix) \(osVersion)"
    }

    var fullDescription: String {
        "\(marketingName) running \(friendlyOSVersion)"
    }
}

extension DeviceSupportEntry {
    init?(folderName: String) {
        let pattern = /^(\w+\d+,\d+)\s+([\d.]+)\s+\(([^)]+)\)$/
        guard let match = folderName.wholeMatch(of: pattern) else { return nil }

        self.folderName = folderName
        self.modelIdentifier = String(match.1)
        self.osVersion = String(match.2)
        self.buildNumber = String(match.3)
        self.marketingName = DeviceModelMap.marketingName(for: self.modelIdentifier)
        self.osPrefix = Self.osPrefix(for: self.modelIdentifier)
    }

    private static func osPrefix(for identifier: String) -> String {
        if identifier.hasPrefix("iPhone") { return "iOS" }
        if identifier.hasPrefix("iPad") { return "iPadOS" }
        if identifier.hasPrefix("AppleTV") { return "tvOS" }
        if identifier.hasPrefix("Watch") { return "watchOS" }
        return "OS"
    }
}
