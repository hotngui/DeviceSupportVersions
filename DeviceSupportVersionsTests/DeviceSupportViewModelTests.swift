//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import Testing
import Foundation
@testable import DeviceSupportVersions

// MARK: - Loading Entries from Disk

@MainActor
struct DeviceSupportViewModelLoadTests {

    /// Creates a temporary directory with the given folder names and returns its path.
    private func makeTempDirectory(folders: [String]) throws -> String {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)

        for name in folders {
            let folder = tmp.appendingPathComponent(name)
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: false)
        }

        return tmp.path(percentEncoded: false)
    }

    /// Removes the temporary directory after the test.
    private func cleanUp(path: String) {
        try? FileManager.default.removeItem(atPath: path)
    }

    @Test func loadsValidFolders() async throws {
        let path = try makeTempDirectory(folders: [
            "iPhone17,2 26.4 (23E246)",
            "iPad16,1 18.4.1 (22E252)",
        ])
        defer { cleanUp(path: path) }

        let vm = DeviceSupportViewModel()
        vm.folderPath = path
        vm.loadEntries()

        #expect(vm.entries.count == 2)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }

    @Test func skipsUnparsableFolderNames() async throws {
        let path = try makeTempDirectory(folders: [
            "iPhone17,2 26.4 (23E246)",
            ".DS_Store_not_a_folder",
            "some random folder",
        ])
        defer { cleanUp(path: path) }

        let vm = DeviceSupportViewModel()
        vm.folderPath = path
        vm.loadEntries()

        // Only the valid folder should appear
        #expect(vm.entries.count == 1)
        #expect(vm.entries.first?.modelIdentifier == "iPhone17,2")
    }

    @Test func setsErrorForNonexistentPath() async {
        let vm = DeviceSupportViewModel()
        vm.folderPath = "/nonexistent/path/that/does/not/exist"
        vm.loadEntries()

        #expect(vm.entries.isEmpty)
        #expect(vm.errorMessage != nil)
    }

    @Test func handlesEmptyDirectory() async throws {
        let path = try makeTempDirectory(folders: [])
        defer { cleanUp(path: path) }

        let vm = DeviceSupportViewModel()
        vm.folderPath = path
        vm.loadEntries()

        #expect(vm.entries.isEmpty)
        #expect(vm.errorMessage == nil)
    }

    @Test func entriesAreSortedByFolderName() async throws {
        let path = try makeTempDirectory(folders: [
            "iPhone17,2 26.4 (23E246)",
            "iPad16,1 18.4 (22E240)",
            "iPhone10,4 16.5.1 (20F75)",
        ])
        defer { cleanUp(path: path) }

        let vm = DeviceSupportViewModel()
        vm.folderPath = path
        vm.loadEntries()

        let folderNames = vm.entries.map(\.folderName)
        #expect(folderNames == folderNames.sorted())
    }
}

// MARK: - Trashing Entries

@MainActor
struct DeviceSupportViewModelTrashTests {

    private func makeTempDirectory(folders: [String]) throws -> String {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)

        for name in folders {
            let folder = tmp.appendingPathComponent(name)
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: false)
        }

        return tmp.path(percentEncoded: false)
    }

    private func cleanUp(path: String) {
        try? FileManager.default.removeItem(atPath: path)
    }

    @Test func trashRemovesEntriesFromList() async throws {
        let path = try makeTempDirectory(folders: [
            "iPhone17,2 26.4 (23E246)",
            "iPad16,1 18.4 (22E240)",
        ])
        defer { cleanUp(path: path) }

        let vm = DeviceSupportViewModel()
        vm.folderPath = path
        vm.loadEntries()

        let idToTrash = vm.entries.first!.id
        try vm.trashEntries(withIDs: [idToTrash])

        #expect(vm.entries.count == 1)
        #expect(!vm.entries.contains(where: { $0.id == idToTrash }))
    }

    @Test func trashRemovesFolderFromDisk() async throws {
        let folderName = "iPhone17,2 26.4 (23E246)"
        let path = try makeTempDirectory(folders: [folderName])
        defer { cleanUp(path: path) }

        let vm = DeviceSupportViewModel()
        vm.folderPath = path
        vm.loadEntries()

        try vm.trashEntries(withIDs: Set(vm.entries.map(\.id)))

        let remaining = try FileManager.default.contentsOfDirectory(atPath: path)
        #expect(!remaining.contains(folderName))
    }

    @Test func trashThrowsForMissingFolder() async throws {
        let path = try makeTempDirectory(folders: [
            "iPhone17,2 26.4 (23E246)",
        ])
        defer { cleanUp(path: path) }

        let vm = DeviceSupportViewModel()
        vm.folderPath = path
        vm.loadEntries()

        // Delete the folder behind the ViewModel's back
        let folderURL = URL(fileURLWithPath: path)
            .appendingPathComponent("iPhone17,2 26.4 (23E246)")
        try FileManager.default.removeItem(at: folderURL)

        #expect(throws: (any Error).self) {
            try vm.trashEntries(withIDs: Set(vm.entries.map(\.id)))
        }
    }
}
