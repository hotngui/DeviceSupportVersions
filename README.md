# DeviceSupportVersions

A lightweight macOS utility for managing Xcode's device support files — the cached symbols and metadata Xcode downloads for each physical device you connect. These files accumulate over time and can consume gigabytes of disk space.

## What It Does

DeviceSupportVersions scans your `~/Library/Developer/Xcode/iOS DeviceSupport` folder (or any folder you choose) and displays all device support entries in a sortable table showing:

- **Folder Name** — the raw folder name as stored on disk
- **Device** — the human-readable marketing name (e.g., "iPhone 15 Pro")
- **OS Version** — the OS and version the symbols were captured for (e.g., "iOS 17.4")
- **Build** — the specific OS build number (e.g., 21E236)

Supports iOS, iPadOS, tvOS, and watchOS device entries.

## Features

- **Sortable table** — click any column header to sort entries
- **Multi-select** — select one or more entries to delete
- **Safe deletion** — moves entries to the Trash (recoverable), never permanently deletes
- **Custom folder** — browse to any DeviceSupport folder, not just the default Xcode location
- **Refresh** — re-scan the folder at any time

## Why It's Useful

Every time you connect a new device or update its OS, Xcode downloads a fresh set of device support files. Old entries are never cleaned up automatically. This app makes it easy to identify and remove outdated entries, recovering potentially gigabytes of disk space.

## Requirements

- macOS 14 (Sonnet) or later
- Xcode (to build)

## License

MIT — see [LICENSE](LICENSE) for details.
