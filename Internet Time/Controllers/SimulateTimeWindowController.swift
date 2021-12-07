//
//  SimulateTimeWindowController.swift
//  Internet Time
//
//  Created by Brad Root on 12/6/21.
//

import Cocoa

class SimulateTimeWindowController: NSWindowController {

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)

        AppDelegate.bringToFront(window: window!)
    }

}
