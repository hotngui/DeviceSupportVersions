//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import Testing
@testable import DeviceSupportVersions

// MARK: - Parsing Valid Folder Names

struct DeviceSupportEntryParsingTests {

    @Test func parsesStandardiPhoneFolder() {
        let entry = DeviceSupportEntry(folderName: "iPhone17,2 26.4 (23E246)")

        #expect(entry != nil)
        #expect(entry?.modelIdentifier == "iPhone17,2")
        #expect(entry?.osVersion == "26.4")
        #expect(entry?.buildNumber == "23E246")
        #expect(entry?.folderName == "iPhone17,2 26.4 (23E246)")
    }

    @Test func parsesThreePartVersion() {
        let entry = DeviceSupportEntry(folderName: "iPhone10,4 16.5.1 (20F75)")

        #expect(entry != nil)
        #expect(entry?.modelIdentifier == "iPhone10,4")
        #expect(entry?.osVersion == "16.5.1")
        #expect(entry?.buildNumber == "20F75")
    }

    @Test func parsesTwoPartVersion() {
        let entry = DeviceSupportEntry(folderName: "iPad13,16 18.0 (22A5282m)")

        #expect(entry != nil)
        #expect(entry?.modelIdentifier == "iPad13,16")
        #expect(entry?.osVersion == "18.0")
        #expect(entry?.buildNumber == "22A5282m")
    }

    @Test func parsesBuildNumberWithLongAlphanumeric() {
        // Some beta builds have unusually long build numbers
        let entry = DeviceSupportEntry(folderName: "iPhone17,2 26.3.1 (23D771330a)")

        #expect(entry != nil)
        #expect(entry?.buildNumber == "23D771330a")
    }

    @Test func parsesiPadFolder() {
        let entry = DeviceSupportEntry(folderName: "iPad16,1 18.4.1 (22E252)")

        #expect(entry != nil)
        #expect(entry?.modelIdentifier == "iPad16,1")
        #expect(entry?.osVersion == "18.4.1")
    }

    @Test func parsesAppleTVFolder() {
        let entry = DeviceSupportEntry(folderName: "AppleTV14,1 18.0 (22J356)")

        #expect(entry != nil)
        #expect(entry?.modelIdentifier == "AppleTV14,1")
    }

    @Test func parsesWatchFolder() {
        let entry = DeviceSupportEntry(folderName: "Watch7,5 11.0 (22R360)")

        #expect(entry != nil)
        #expect(entry?.modelIdentifier == "Watch7,5")
    }

    @Test func parsesiPodFolder() {
        let entry = DeviceSupportEntry(folderName: "iPod9,1 15.7 (19H12)")

        #expect(entry != nil)
        #expect(entry?.modelIdentifier == "iPod9,1")
    }
}

// MARK: - Parsing Invalid Folder Names

struct DeviceSupportEntryInvalidInputTests {

    @Test func rejectsEmptyString() {
        #expect(DeviceSupportEntry(folderName: "") == nil)
    }

    @Test func rejectsMissingBuildNumber() {
        #expect(DeviceSupportEntry(folderName: "iPhone17,2 26.4") == nil)
    }

    @Test func rejectsMissingVersion() {
        #expect(DeviceSupportEntry(folderName: "iPhone17,2 (23E246)") == nil)
    }

    @Test func rejectsMissingModelIdentifier() {
        #expect(DeviceSupportEntry(folderName: "26.4 (23E246)") == nil)
    }

    @Test func rejectsNoCommaInModel() {
        #expect(DeviceSupportEntry(folderName: "iPhone17 26.4 (23E246)") == nil)
    }

    @Test func rejectsRandomText() {
        #expect(DeviceSupportEntry(folderName: "not a device folder") == nil)
    }

    @Test func rejectsPartialMatch() {
        // Extra text after closing paren should fail whole-match
        #expect(DeviceSupportEntry(folderName: "iPhone17,2 26.4 (23E246) extra") == nil)
    }

    @Test func rejectsLeadingWhitespace() {
        #expect(DeviceSupportEntry(folderName: " iPhone17,2 26.4 (23E246)") == nil)
    }
}

// MARK: - OS Prefix Logic

struct DeviceSupportEntryOSPrefixTests {

    @Test func iPhoneGetsIOSPrefix() {
        let entry = DeviceSupportEntry(folderName: "iPhone17,2 26.4 (23E246)")
        #expect(entry?.osPrefix == "iOS")
    }

    @Test func iPadGetsIPadOSPrefix() {
        let entry = DeviceSupportEntry(folderName: "iPad16,1 18.4 (22E240)")
        #expect(entry?.osPrefix == "iPadOS")
    }

    @Test func appleTVGetsTvOSPrefix() {
        let entry = DeviceSupportEntry(folderName: "AppleTV14,1 18.0 (22J356)")
        #expect(entry?.osPrefix == "tvOS")
    }

    @Test func watchGetsWatchOSPrefix() {
        let entry = DeviceSupportEntry(folderName: "Watch7,5 11.0 (22R360)")
        #expect(entry?.osPrefix == "watchOS")
    }

    @Test func iPodGetsOSPrefix() {
        let entry = DeviceSupportEntry(folderName: "iPod9,1 15.7 (19H12)")
        // iPod doesn't match any specific prefix, falls back to "OS"
        #expect(entry?.osPrefix == "OS")
    }
}

// MARK: - Computed Properties

struct DeviceSupportEntryComputedPropertyTests {

    @Test func friendlyOSVersionCombinesPrefixAndVersion() {
        let entry = DeviceSupportEntry(folderName: "iPhone17,2 26.4 (23E246)")
        #expect(entry?.friendlyOSVersion == "iOS 26.4")
    }

    @Test func friendlyOSVersionForiPad() {
        let entry = DeviceSupportEntry(folderName: "iPad16,1 18.4 (22E240)")
        #expect(entry?.friendlyOSVersion == "iPadOS 18.4")
    }

    @Test func fullDescriptionCombinesNameAndOS() {
        let entry = DeviceSupportEntry(folderName: "iPhone17,2 26.4 (23E246)")
        #expect(entry?.fullDescription == "iPhone 16 Pro Max running iOS 26.4")
    }

    @Test func fullDescriptionForUnknownModelUsesRawIdentifier() {
        let entry = DeviceSupportEntry(folderName: "iPhone99,1 30.0 (99A100)")
        #expect(entry?.fullDescription == "iPhone99,1 running iOS 30.0")
    }

    @Test func marketingNameLooksUpFromMap() {
        let entry = DeviceSupportEntry(folderName: "iPad8,10 26.3 (23D127)")
        #expect(entry?.marketingName == "iPad Pro (11-inch) (2nd generation)")
    }

    @Test func eachEntryHasUniqueID() {
        let a = DeviceSupportEntry(folderName: "iPhone17,2 26.4 (23E246)")
        let b = DeviceSupportEntry(folderName: "iPhone17,2 26.4 (23E246)")
        #expect(a?.id != b?.id)
    }
}
