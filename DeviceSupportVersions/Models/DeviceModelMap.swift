//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import Foundation

/// Maps Apple hardware model identifiers to their consumer-facing marketing names.
///
/// ## How these mappings were determined
///
/// Every Apple device contains a hardware model identifier accessible via the `hw.machine`
/// sysctl key (e.g., `sysctlbyname("hw.machine", ...)`). These identifiers follow the format
/// `{DeviceFamily}{Generation},{Variant}`:
///
/// - **DeviceFamily**: The product line — `iPhone`, `iPad`, `iPod`, `Watch`, or `AppleTV`.
/// - **Generation**: A number that generally increments with each new hardware generation,
///   though it does not always correspond 1-to-1 with the marketing generation number.
///   For example, `iPhone14,x` maps to both iPhone 13 and iPhone SE (3rd generation).
/// - **Variant**: Distinguishes sub-models within the same generation. Variants typically
///   differ by connectivity (Wi-Fi-only vs. Wi-Fi + Cellular), storage tier, modem
///   (Qualcomm vs. Intel), or regional SKU (e.g., different cellular bands for China).
///
/// ## Sources
///
/// The definitive source for these mappings is Apple's own device identification pages:
///   - https://support.apple.com/en-us/103909  (Identify your iPhone model)
///   - https://support.apple.com/en-us/103908  (Identify your iPad model)
///
/// These Apple support pages list the model identifier for every device. Additional
/// community-maintained references that aggregate this data include:
///   - The iPhone Wiki (https://www.theiphonewiki.com/wiki/Models)
///   - ipsw.me device listings
///   - Xcode's own DVTDeviceKnowledge framework (embedded in Xcode.app)
///
/// ## Why multiple identifiers map to the same marketing name
///
/// Apple frequently ships the same product as two or more hardware variants. Common reasons:
///   - **Connectivity**: Wi-Fi-only vs. Wi-Fi + Cellular (iPads)
///   - **Modem vendor**: Intel modem vs. Qualcomm modem (iPhone 7 through iPhone XS era)
///   - **Regional SKU**: Different cellular band support for specific markets (e.g., China)
///   - **Storage tier**: Some iPad Pro models had a different identifier for 1TB+ SKUs
///     because they shipped with more RAM
///
/// ## Maintenance
///
/// This dictionary must be updated when Apple releases new hardware. If a folder name
/// contains an identifier not present here, `marketingName(for:)` returns the raw
/// identifier as a fallback so the app still displays useful information.
///
/// Last verified: March 2026
enum DeviceModelMap {
    /// Returns the consumer marketing name for a given hardware model identifier.
    /// Falls back to returning the raw identifier if no mapping is found.
    static func marketingName(for identifier: String) -> String {
        models[identifier] ?? identifier
    }

    private static let models: [String: String] = [

        // =====================================================================
        // MARK: - iPhone
        // =====================================================================
        // Source: https://support.apple.com/en-us/103909
        //
        // The iPhone family identifier starts at "iPhone1,1" (original 2007 iPhone).
        // The generation number in the identifier does NOT match the product name.
        // For example, "iPhone10,x" = iPhone 8/X, "iPhone14,x" = iPhone 13/SE 3rd gen.
        // Odd/even variants within a generation typically distinguish modem vendors
        // (Qualcomm vs. Intel) or global vs. regional (GSM vs. CDMA) SKUs.
        // =====================================================================

        // iPhone (2007) — the original
        "iPhone1,1": "iPhone",

        // iPhone 3G (2008)
        "iPhone1,2": "iPhone 3G",

        // iPhone 3GS (2009)
        "iPhone2,1": "iPhone 3GS",

        // iPhone 4 (2010) — three variants for GSM, GSM rev A, and CDMA
        "iPhone3,1": "iPhone 4",
        "iPhone3,2": "iPhone 4",
        "iPhone3,3": "iPhone 4",

        // iPhone 4S (2011)
        "iPhone4,1": "iPhone 4S",

        // iPhone 5 (2012) — GSM and CDMA variants
        "iPhone5,1": "iPhone 5",
        "iPhone5,2": "iPhone 5",

        // iPhone 5c (2013) — GSM and CDMA variants
        "iPhone5,3": "iPhone 5c",
        "iPhone5,4": "iPhone 5c",

        // iPhone 5s (2013) — first 64-bit iPhone (A7); GSM and CDMA variants
        "iPhone6,1": "iPhone 5s",
        "iPhone6,2": "iPhone 5s",

        // iPhone 6 and 6 Plus (2014) — first large-screen iPhones
        "iPhone7,1": "iPhone 6 Plus",
        "iPhone7,2": "iPhone 6",

        // iPhone 6s and 6s Plus (2015) — introduced 3D Touch
        "iPhone8,1": "iPhone 6s",
        "iPhone8,2": "iPhone 6s Plus",

        // iPhone SE (1st generation, 2016) — 4-inch form factor with A9 chip
        "iPhone8,4": "iPhone SE (1st generation)",

        // iPhone 7 and 7 Plus (2016)
        // Variants 1,2 = Qualcomm modem (Verizon/Sprint); 3,4 = Intel modem (AT&T/T-Mobile)
        "iPhone9,1": "iPhone 7",
        "iPhone9,2": "iPhone 7 Plus",
        "iPhone9,3": "iPhone 7",
        "iPhone9,4": "iPhone 7 Plus",

        // iPhone 8, 8 Plus, and X (2017)
        // Variants 1,2,3 = Qualcomm modem; 4,5,6 = Intel modem
        "iPhone10,1": "iPhone 8",
        "iPhone10,2": "iPhone 8 Plus",
        "iPhone10,3": "iPhone X",
        "iPhone10,4": "iPhone 8",
        "iPhone10,5": "iPhone 8 Plus",
        "iPhone10,6": "iPhone X",

        // iPhone XS, XS Max, and XR (2018) — first iPhones with Intel-only modems
        "iPhone11,2": "iPhone XS",
        "iPhone11,4": "iPhone XS Max",        // China variant (dual physical SIM)
        "iPhone11,6": "iPhone XS Max",        // Rest of world (nano-SIM + eSIM)
        "iPhone11,8": "iPhone XR",

        // iPhone 11, 11 Pro, and 11 Pro Max (2019)
        "iPhone12,1": "iPhone 11",
        "iPhone12,3": "iPhone 11 Pro",
        "iPhone12,5": "iPhone 11 Pro Max",

        // iPhone SE (2nd generation, 2020) — iPhone 8 body with A13 chip
        "iPhone12,8": "iPhone SE (2nd generation)",

        // iPhone 12 family (2020) — first 5G iPhones, returned to flat-edge design
        "iPhone13,1": "iPhone 12 mini",
        "iPhone13,2": "iPhone 12",
        "iPhone13,3": "iPhone 12 Pro",
        "iPhone13,4": "iPhone 12 Pro Max",

        // iPhone 13 family (2021)
        "iPhone14,2": "iPhone 13 Pro",
        "iPhone14,3": "iPhone 13 Pro Max",
        "iPhone14,4": "iPhone 13 mini",
        "iPhone14,5": "iPhone 13",

        // iPhone SE (3rd generation, 2022) — iPhone 8 body with A15 chip and 5G
        "iPhone14,6": "iPhone SE (3rd generation)",

        // iPhone 14 family (2022) — dropped "mini", added "Plus"
        "iPhone14,7": "iPhone 14",
        "iPhone14,8": "iPhone 14 Plus",
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",

        // iPhone 15 family (2023) — switched to USB-C, Dynamic Island on all models
        "iPhone15,4": "iPhone 15",
        "iPhone15,5": "iPhone 15 Plus",
        "iPhone16,1": "iPhone 15 Pro",
        "iPhone16,2": "iPhone 15 Pro Max",

        // iPhone 16 family (2024) — Camera Control button, A18 chip
        "iPhone17,1": "iPhone 16 Pro",
        "iPhone17,2": "iPhone 16 Pro Max",
        "iPhone17,3": "iPhone 16",
        "iPhone17,4": "iPhone 16 Plus",

        // iPhone 16e (2025) — replaced SE line with "e" branding, first eSIM-only SE
        "iPhone17,5": "iPhone 16e",

        // =====================================================================
        // MARK: - iPad
        // =====================================================================
        // Source: https://support.apple.com/en-us/103908
        //
        // iPad identifiers are more numerous because each model typically ships
        // in both Wi-Fi-only and Wi-Fi + Cellular variants. Some iPad Pro models
        // also have separate identifiers for high-storage (1TB+) SKUs that include
        // additional RAM.
        // =====================================================================

        // iPad (1st generation, 2010)
        "iPad1,1": "iPad",

        // iPad 2 (2011) — Wi-Fi, GSM, CDMA variants
        "iPad2,1": "iPad 2",
        "iPad2,2": "iPad 2",
        "iPad2,3": "iPad 2",
        "iPad2,4": "iPad 2",               // Mid-2012 revision with updated processor

        // iPad mini (1st generation, 2012)
        "iPad2,5": "iPad mini",
        "iPad2,6": "iPad mini",
        "iPad2,7": "iPad mini",

        // iPad (3rd generation, 2012) — first Retina iPad
        "iPad3,1": "iPad (3rd generation)",
        "iPad3,2": "iPad (3rd generation)",
        "iPad3,3": "iPad (3rd generation)",

        // iPad (4th generation, 2012) — first iPad with Lightning connector
        "iPad3,4": "iPad (4th generation)",
        "iPad3,5": "iPad (4th generation)",
        "iPad3,6": "iPad (4th generation)",

        // iPad Air (1st generation, 2013)
        "iPad4,1": "iPad Air",
        "iPad4,2": "iPad Air",
        "iPad4,3": "iPad Air",              // China-specific variant

        // iPad mini 2 (2013) — first Retina iPad mini
        "iPad4,4": "iPad mini 2",
        "iPad4,5": "iPad mini 2",
        "iPad4,6": "iPad mini 2",

        // iPad mini 3 (2014) — added Touch ID
        "iPad4,7": "iPad mini 3",
        "iPad4,8": "iPad mini 3",
        "iPad4,9": "iPad mini 3",

        // iPad mini 4 (2015)
        "iPad5,1": "iPad mini 4",
        "iPad5,2": "iPad mini 4",

        // iPad Air 2 (2014) — first iPad with Touch ID
        "iPad5,3": "iPad Air 2",
        "iPad5,4": "iPad Air 2",

        // iPad Pro (9.7-inch, 2016)
        "iPad6,3": "iPad Pro (9.7-inch)",
        "iPad6,4": "iPad Pro (9.7-inch)",

        // iPad Pro (12.9-inch, 1st generation, 2015) — first iPad Pro
        "iPad6,7": "iPad Pro (12.9-inch)",
        "iPad6,8": "iPad Pro (12.9-inch)",

        // iPad (5th generation, 2017)
        "iPad6,11": "iPad (5th generation)",
        "iPad6,12": "iPad (5th generation)",

        // iPad Pro (12.9-inch, 2nd generation, 2017) — ProMotion 120Hz display
        "iPad7,1": "iPad Pro (12.9-inch) (2nd generation)",
        "iPad7,2": "iPad Pro (12.9-inch) (2nd generation)",

        // iPad Pro (10.5-inch, 2017)
        "iPad7,3": "iPad Pro (10.5-inch)",
        "iPad7,4": "iPad Pro (10.5-inch)",

        // iPad (6th generation, 2018) — first non-Pro iPad with Apple Pencil support
        "iPad7,5": "iPad (6th generation)",
        "iPad7,6": "iPad (6th generation)",

        // iPad (7th generation, 2019) — 10.2-inch display
        "iPad7,11": "iPad (7th generation)",
        "iPad7,12": "iPad (7th generation)",

        // iPad Pro (11-inch, 1st generation, 2018) — first iPad with Face ID, USB-C
        // Variants 1-2 = standard storage; 3-4 = 1TB (shipped with 6GB RAM vs 4GB)
        "iPad8,1": "iPad Pro (11-inch)",
        "iPad8,2": "iPad Pro (11-inch)",
        "iPad8,3": "iPad Pro (11-inch)",
        "iPad8,4": "iPad Pro (11-inch)",

        // iPad Pro (12.9-inch, 3rd generation, 2018)
        // Variants 5-6 = standard storage; 7-8 = 1TB (shipped with 6GB RAM vs 4GB)
        "iPad8,5": "iPad Pro (12.9-inch) (3rd generation)",
        "iPad8,6": "iPad Pro (12.9-inch) (3rd generation)",
        "iPad8,7": "iPad Pro (12.9-inch) (3rd generation)",
        "iPad8,8": "iPad Pro (12.9-inch) (3rd generation)",

        // iPad Pro (11-inch, 2nd generation, 2020) — added LiDAR scanner
        "iPad8,9": "iPad Pro (11-inch) (2nd generation)",
        "iPad8,10": "iPad Pro (11-inch) (2nd generation)",

        // iPad Pro (12.9-inch, 4th generation, 2020)
        "iPad8,11": "iPad Pro (12.9-inch) (4th generation)",
        "iPad8,12": "iPad Pro (12.9-inch) (4th generation)",

        // iPad mini (5th generation, 2019)
        "iPad11,1": "iPad mini (5th generation)",
        "iPad11,2": "iPad mini (5th generation)",

        // iPad Air (3rd generation, 2019)
        "iPad11,3": "iPad Air (3rd generation)",
        "iPad11,4": "iPad Air (3rd generation)",

        // iPad (8th generation, 2020)
        "iPad11,6": "iPad (8th generation)",
        "iPad11,7": "iPad (8th generation)",

        // iPad (9th generation, 2021) — last iPad with Home button and Lightning
        "iPad12,1": "iPad (9th generation)",
        "iPad12,2": "iPad (9th generation)",

        // iPad Air (4th generation, 2020) — first iPad Air with USB-C and flat edges
        "iPad13,1": "iPad Air (4th generation)",
        "iPad13,2": "iPad Air (4th generation)",

        // iPad Pro (11-inch, 3rd generation, 2021) — M1 chip
        // Four variants cover Wi-Fi/Cellular and standard/1TB+ storage tiers
        "iPad13,4": "iPad Pro (11-inch) (3rd generation)",
        "iPad13,5": "iPad Pro (11-inch) (3rd generation)",
        "iPad13,6": "iPad Pro (11-inch) (3rd generation)",
        "iPad13,7": "iPad Pro (11-inch) (3rd generation)",

        // iPad Pro (12.9-inch, 5th generation, 2021) — M1 chip, Liquid Retina XDR
        "iPad13,8": "iPad Pro (12.9-inch) (5th generation)",
        "iPad13,9": "iPad Pro (12.9-inch) (5th generation)",
        "iPad13,10": "iPad Pro (12.9-inch) (5th generation)",
        "iPad13,11": "iPad Pro (12.9-inch) (5th generation)",

        // iPad Air (5th generation, 2022) — M1 chip
        "iPad13,16": "iPad Air (5th generation)",
        "iPad13,17": "iPad Air (5th generation)",

        // iPad (10th generation, 2022) — USB-C, landscape front camera, no Home button
        "iPad13,18": "iPad (10th generation)",
        "iPad13,19": "iPad (10th generation)",

        // iPad mini (6th generation, 2021) — USB-C, flat edges, A15 chip
        "iPad14,1": "iPad mini (6th generation)",
        "iPad14,2": "iPad mini (6th generation)",

        // iPad Pro (11-inch, 4th generation, 2022) — M2 chip
        "iPad14,3": "iPad Pro (11-inch) (4th generation)",
        "iPad14,4": "iPad Pro (11-inch) (4th generation)",

        // iPad Pro (12.9-inch, 6th generation, 2022) — M2 chip
        "iPad14,5": "iPad Pro (12.9-inch) (6th generation)",
        "iPad14,6": "iPad Pro (12.9-inch) (6th generation)",

        // iPad Air (M2, 11-inch, 2024) — first Air in two sizes
        "iPad14,8": "iPad Air (M2, 11-inch)",
        "iPad14,9": "iPad Air (M2, 11-inch)",

        // iPad Air (M2, 13-inch, 2024)
        "iPad14,10": "iPad Air (M2, 13-inch)",
        "iPad14,11": "iPad Air (M2, 13-inch)",

        // iPad Pro (M4, 11-inch, 2024) — OLED tandem display, thinnest Apple device
        "iPad16,1": "iPad Pro (M4, 11-inch)",
        "iPad16,2": "iPad Pro (M4, 11-inch)",

        // iPad Pro (M4, 13-inch, 2024)
        "iPad16,3": "iPad Pro (M4, 13-inch)",
        "iPad16,4": "iPad Pro (M4, 13-inch)",

        // iPad mini (A17 Pro, 7th generation, 2024) — Apple Intelligence support
        "iPad16,5": "iPad mini (A17 Pro, 7th generation)",
        "iPad16,6": "iPad mini (A17 Pro, 7th generation)",

        // =====================================================================
        // MARK: - iPod touch
        // =====================================================================
        // Apple discontinued the iPod touch line in 2022. Only the last few
        // generations are likely to appear in modern DeviceSupport folders.
        // =====================================================================

        // iPod touch (5th generation, 2012)
        "iPod5,1": "iPod touch (5th generation)",

        // iPod touch (6th generation, 2015) — A8 chip, first 64-bit iPod
        "iPod7,1": "iPod touch (6th generation)",

        // iPod touch (7th generation, 2019) — A10 Fusion, last iPod ever made
        "iPod9,1": "iPod touch (7th generation)",

        // =====================================================================
        // MARK: - Apple TV
        // =====================================================================
        // Apple TV DeviceSupport folders appear under tvOS DeviceSupport.
        // Included here for completeness since the folder picker allows
        // selecting any DeviceSupport directory.
        // =====================================================================

        // Apple TV (3rd generation, 2012)
        "AppleTV3,1": "Apple TV (3rd generation)",
        "AppleTV3,2": "Apple TV (3rd generation)",

        // Apple TV HD (4th generation, 2015) — first Apple TV with App Store (tvOS)
        "AppleTV5,3": "Apple TV HD",

        // Apple TV 4K (1st generation, 2017)
        "AppleTV6,2": "Apple TV 4K",

        // Apple TV 4K (2nd generation, 2021) — A12 Bionic
        "AppleTV11,1": "Apple TV 4K (2nd generation)",

        // Apple TV 4K (3rd generation, 2022) — A15 Bionic, USB-C
        "AppleTV14,1": "Apple TV 4K (3rd generation)",

        // =====================================================================
        // MARK: - Apple Watch
        // =====================================================================
        // Apple Watch DeviceSupport folders appear under watchOS DeviceSupport.
        // Included for completeness. Odd/even variants typically distinguish
        // case sizes (e.g., 40mm vs 44mm) and GPS-only vs GPS + Cellular.
        // =====================================================================

        // Apple Watch (1st generation, 2015)
        "Watch1,1": "Apple Watch (1st generation) (38mm)",
        "Watch1,2": "Apple Watch (1st generation) (42mm)",

        // Apple Watch Series 1 (2016) — updated processor, no GPS/Cellular
        "Watch2,6": "Apple Watch Series 1 (38mm)",
        "Watch2,7": "Apple Watch Series 1 (42mm)",

        // Apple Watch Series 2 (2016) — first with GPS
        "Watch2,3": "Apple Watch Series 2 (38mm)",
        "Watch2,4": "Apple Watch Series 2 (42mm)",

        // Apple Watch Series 3 (2017) — first with optional LTE
        "Watch3,1": "Apple Watch Series 3 (38mm, GPS + Cellular)",
        "Watch3,2": "Apple Watch Series 3 (42mm, GPS + Cellular)",
        "Watch3,3": "Apple Watch Series 3 (38mm, GPS)",
        "Watch3,4": "Apple Watch Series 3 (42mm, GPS)",

        // Apple Watch Series 4 (2018) — larger displays (40mm/44mm), ECG
        "Watch4,1": "Apple Watch Series 4 (40mm, GPS)",
        "Watch4,2": "Apple Watch Series 4 (44mm, GPS)",
        "Watch4,3": "Apple Watch Series 4 (40mm, GPS + Cellular)",
        "Watch4,4": "Apple Watch Series 4 (44mm, GPS + Cellular)",

        // Apple Watch Series 5 (2019) — always-on display
        "Watch5,1": "Apple Watch Series 5 (40mm, GPS)",
        "Watch5,2": "Apple Watch Series 5 (44mm, GPS)",
        "Watch5,3": "Apple Watch Series 5 (40mm, GPS + Cellular)",
        "Watch5,4": "Apple Watch Series 5 (44mm, GPS + Cellular)",

        // Apple Watch SE (1st generation, 2020)
        "Watch5,9": "Apple Watch SE (40mm, GPS)",
        "Watch5,10": "Apple Watch SE (44mm, GPS)",
        "Watch5,11": "Apple Watch SE (40mm, GPS + Cellular)",
        "Watch5,12": "Apple Watch SE (44mm, GPS + Cellular)",

        // Apple Watch Series 6 (2020) — blood oxygen sensor
        "Watch6,1": "Apple Watch Series 6 (40mm, GPS)",
        "Watch6,2": "Apple Watch Series 6 (44mm, GPS)",
        "Watch6,3": "Apple Watch Series 6 (40mm, GPS + Cellular)",
        "Watch6,4": "Apple Watch Series 6 (44mm, GPS + Cellular)",

        // Apple Watch Series 7 (2021) — larger displays (41mm/45mm)
        "Watch6,6": "Apple Watch Series 7 (41mm, GPS)",
        "Watch6,7": "Apple Watch Series 7 (45mm, GPS)",
        "Watch6,8": "Apple Watch Series 7 (41mm, GPS + Cellular)",
        "Watch6,9": "Apple Watch Series 7 (45mm, GPS + Cellular)",

        // Apple Watch SE (2nd generation, 2022)
        "Watch6,10": "Apple Watch SE (2nd generation) (40mm, GPS)",
        "Watch6,11": "Apple Watch SE (2nd generation) (44mm, GPS)",
        "Watch6,12": "Apple Watch SE (2nd generation) (40mm, GPS + Cellular)",
        "Watch6,13": "Apple Watch SE (2nd generation) (44mm, GPS + Cellular)",

        // Apple Watch Series 8 (2022) — crash detection, temperature sensing
        "Watch6,14": "Apple Watch Series 8 (41mm, GPS)",
        "Watch6,15": "Apple Watch Series 8 (45mm, GPS)",
        "Watch6,16": "Apple Watch Series 8 (41mm, GPS + Cellular)",
        "Watch6,17": "Apple Watch Series 8 (45mm, GPS + Cellular)",

        // Apple Watch Ultra (2022) — 49mm titanium case, Action button
        "Watch6,18": "Apple Watch Ultra",

        // Apple Watch Series 9 (2023)
        "Watch7,1": "Apple Watch Series 9 (41mm, GPS)",
        "Watch7,2": "Apple Watch Series 9 (45mm, GPS)",
        "Watch7,3": "Apple Watch Series 9 (41mm, GPS + Cellular)",
        "Watch7,4": "Apple Watch Series 9 (45mm, GPS + Cellular)",

        // Apple Watch Ultra 2 (2023)
        "Watch7,5": "Apple Watch Ultra 2",

        // Apple Watch Series 10 (2024)
        "Watch7,8": "Apple Watch Series 10 (42mm, GPS)",
        "Watch7,9": "Apple Watch Series 10 (46mm, GPS)",
        "Watch7,10": "Apple Watch Series 10 (42mm, GPS + Cellular)",
        "Watch7,11": "Apple Watch Series 10 (46mm, GPS + Cellular)",
    ]
}
