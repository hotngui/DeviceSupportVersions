//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import Testing
@testable import DeviceSupportVersions

// MARK: - Known Device Lookups

struct DeviceModelMapKnownDeviceTests {

    // Spot-check one device per major iPhone generation to catch accidental
    // dictionary edits that corrupt unrelated entries.

    @Test func mapsOriginalIPhone() {
        #expect(DeviceModelMap.marketingName(for: "iPhone1,1") == "iPhone")
    }

    @Test func mapsiPhone5s() {
        #expect(DeviceModelMap.marketingName(for: "iPhone6,1") == "iPhone 5s")
    }

    @Test func mapsiPhoneSE1stGen() {
        #expect(DeviceModelMap.marketingName(for: "iPhone8,4") == "iPhone SE (1st generation)")
    }

    @Test func mapsiPhoneX() {
        #expect(DeviceModelMap.marketingName(for: "iPhone10,3") == "iPhone X")
    }

    @Test func mapsiPhoneXIntelVariant() {
        // Intel modem variant should map to the same marketing name
        #expect(DeviceModelMap.marketingName(for: "iPhone10,6") == "iPhone X")
    }

    @Test func mapsiPhone11() {
        #expect(DeviceModelMap.marketingName(for: "iPhone12,1") == "iPhone 11")
    }

    @Test func mapsiPhoneSE2ndGen() {
        #expect(DeviceModelMap.marketingName(for: "iPhone12,8") == "iPhone SE (2nd generation)")
    }

    @Test func mapsiPhone12ProMax() {
        #expect(DeviceModelMap.marketingName(for: "iPhone13,4") == "iPhone 12 Pro Max")
    }

    @Test func mapsiPhone14ProMax() {
        #expect(DeviceModelMap.marketingName(for: "iPhone15,3") == "iPhone 14 Pro Max")
    }

    @Test func mapsiPhone15ProMax() {
        #expect(DeviceModelMap.marketingName(for: "iPhone16,2") == "iPhone 15 Pro Max")
    }

    @Test func mapsiPhone16ProMax() {
        #expect(DeviceModelMap.marketingName(for: "iPhone17,2") == "iPhone 16 Pro Max")
    }

    @Test func mapsiPhone16e() {
        #expect(DeviceModelMap.marketingName(for: "iPhone17,5") == "iPhone 16e")
    }
}

struct DeviceModelMapiPadTests {

    @Test func mapsOriginalIPad() {
        #expect(DeviceModelMap.marketingName(for: "iPad1,1") == "iPad")
    }

    @Test func mapsIPadAir4thGen() {
        #expect(DeviceModelMap.marketingName(for: "iPad13,1") == "iPad Air (4th generation)")
    }

    @Test func mapsIPadProM4() {
        #expect(DeviceModelMap.marketingName(for: "iPad16,1") == "iPad Pro (M4, 11-inch)")
    }

    @Test func mapsIPadMiniA17Pro() {
        #expect(DeviceModelMap.marketingName(for: "iPad16,5") == "iPad mini (A17 Pro, 7th generation)")
    }

    @Test func mapsIPadPro11Inch2ndGen() {
        #expect(DeviceModelMap.marketingName(for: "iPad8,10") == "iPad Pro (11-inch) (2nd generation)")
    }

    @Test func wifiAndCellularVariantsMapToSameName() {
        let wifi = DeviceModelMap.marketingName(for: "iPad14,3")
        let cellular = DeviceModelMap.marketingName(for: "iPad14,4")
        #expect(wifi == cellular)
        #expect(wifi == "iPad Pro (11-inch) (4th generation)")
    }
}

struct DeviceModelMapOtherDeviceTests {

    @Test func mapsAppleTVHD() {
        #expect(DeviceModelMap.marketingName(for: "AppleTV5,3") == "Apple TV HD")
    }

    @Test func mapsAppleTV4K3rdGen() {
        #expect(DeviceModelMap.marketingName(for: "AppleTV14,1") == "Apple TV 4K (3rd generation)")
    }

    @Test func mapsAppleWatchUltra2() {
        #expect(DeviceModelMap.marketingName(for: "Watch7,5") == "Apple Watch Ultra 2")
    }

    @Test func mapsIPodTouch7thGen() {
        #expect(DeviceModelMap.marketingName(for: "iPod9,1") == "iPod touch (7th generation)")
    }
}

// MARK: - Unknown / Fallback Behavior

struct DeviceModelMapFallbackTests {

    @Test func unknownIdentifierReturnsSelf() {
        #expect(DeviceModelMap.marketingName(for: "iPhone99,1") == "iPhone99,1")
    }

    @Test func emptyStringReturnsSelf() {
        #expect(DeviceModelMap.marketingName(for: "") == "")
    }

    @Test func nonsenseStringReturnsSelf() {
        #expect(DeviceModelMap.marketingName(for: "NotADevice") == "NotADevice")
    }
}
