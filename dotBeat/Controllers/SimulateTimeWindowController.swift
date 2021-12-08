//
//  SimulateTimeWindowController.swift
//  dotBeat
//
//  Created by Brad Root on 12/6/21.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Cocoa
import AppKit

class SimulateTimeWindowController: NSWindowController {

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)

        AppDelegate.bringToFront(window: window!)
    }
    
    override func windowDidLoad() {
        Log.debug("Window did load")
        if let window = window, let screen = window.screen {
        let screenRect = screen.visibleFrame
            window.setFrameOrigin(NSPoint(
                x: 20,
                y: screenRect.maxY - window.frame.height - 10
            ))
        }
    }

}
