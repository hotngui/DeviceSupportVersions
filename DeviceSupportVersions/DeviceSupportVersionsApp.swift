//
// Created by Joey Jarosz on 3/26/26.
// Copyright (c) 2026 hot-n-GUI, LLC. All rights reserved.
//
// Licensed under the MIT License.
// See https://opensource.org/licenses/MIT for details.
//

import SwiftUI

@main
struct DeviceSupportVersionsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    if ProcessInfo.processInfo.environment["UI_TESTING"] == "1",
                       let window = NSApp.windows.first,
                       let screen = NSScreen.screens.first {
                        let frame = screen.visibleFrame
                        window.setFrameOrigin(NSPoint(
                            x: frame.midX - window.frame.width / 2,
                            y: frame.midY - window.frame.height / 2
                        ))
                    }
                }
        }
        .defaultSize(width: 900, height: 600)
    }
}
