//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import XCTest

@MainActor
final class DeviceSupportUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launchEnvironment["UI_TESTING"] = "1"
        app.launch()
    }

    override func tearDown() async throws {
        app = nil
    }

    /// Verifies the table is visible and populated after launch.
    func testTableAppearsOnLaunch() {
        let table = app.outlines["DeviceSupportTable"]
        XCTAssertTrue(table.waitForExistence(timeout: 5), "Table should appear after launch")
        XCTAssertGreaterThan(table.outlineRows.count, 0, "Table should contain at least one row")
    }

    /// Selects a row, taps Trash, verifies the confirmation dialog appears, then cancels
    /// — ensuring nothing is actually deleted.
    func testSelectRowAndCancelTrash() {
        let table = app.outlines["DeviceSupportTable"]
        XCTAssertTrue(table.waitForExistence(timeout: 5), "Table should appear")

        let initialRowCount = table.outlineRows.count
        guard initialRowCount > 0 else {
            XCTFail("No rows to select — is the DeviceSupport folder empty?")
            return
        }

        // Select the first row via coordinate click (outline rows are not directly hittable)
        let firstRow = table.outlineRows.element(boundBy: 0)
        firstRow.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).click()

        // Verify status bar reflects the selection (SwiftUI Text exposes content via .value on macOS)
        let statusText = app.staticTexts["StatusBarText"]
        let selectedPredicate = NSPredicate(format: "value CONTAINS 'selected'")
        expectation(for: selectedPredicate, evaluatedWith: statusText, handler: nil)
        waitForExpectations(timeout: 5)

        // Click the Trash toolbar button
        let trashButton = app.buttons["TrashButton"]
        XCTAssertTrue(trashButton.isEnabled, "Trash button should be enabled when a row is selected")
        trashButton.click()

        // Verify the confirmation dialog appears
        let dialog = app.sheets.firstMatch
        XCTAssertTrue(dialog.waitForExistence(timeout: 3), "Confirmation dialog should appear")

        // Cancel the dialog — nothing should be deleted
        let cancelButton = dialog.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Cancel button should be present in dialog")
        cancelButton.click()

        // Verify the table still has the same number of rows
        XCTAssertEqual(table.outlineRows.count, initialRowCount, "No rows should have been removed after cancelling")
    }
}
