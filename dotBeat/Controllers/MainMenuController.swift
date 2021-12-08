//
//  MainMenuController.swift
//  dotBeat
//
//  Created by Brad Root on 12/6/21.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Cocoa

class MainMenuController: NSObject, NSMenuDelegate {
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBOutlet var mainMenu: NSMenu!
    
    private var timer: Timer?
    private var updateInterval: TimeInterval
    
    @IBAction func quitMenuBarAction(_: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    private lazy var aboutWindowController = NSStoryboard(
        name: "Main",
        bundle: nil
    ).instantiateController(
        withIdentifier: "AboutWindowController"
    ) as? NSWindowController
    
    @IBAction func aboutAction(_: NSMenuItem) {
        aboutWindowController?.showWindow(self)
    }
    
    private lazy var simulateTimeWindowController = NSStoryboard(
        name: "Main",
        bundle: nil
    ).instantiateController(
        withIdentifier: "SimulateTimeWindowController"
    ) as? NSWindowController
    
    @IBAction func simulateAction(_: NSMenuItem) {
        simulateTimeWindowController?.showWindow(self)
    }
    
    // MARK: - View Lifecycle
    
    override init() {
        updateInterval = TimeInterval(3)
        
        Log.logLevel = .debug
        Log.useEmoji = true
        
        super.init()
    }
    
    override func awakeFromNib() {
        if let statusBarButton = statusBarItem.button {
            statusBarButton.image = NSImage(named: "icon")
            statusBarButton.imagePosition = .imageLeading
            
            let date = Date()
            
            statusBarButton.title = "\(Int(date.beats))"
        }
        statusBarItem.menu = mainMenu
        mainMenu.delegate = self
        
        startTimer()
    }
    
    @objc func updateInternetTime() {
        if let statusBarButton = statusBarItem.button {
            let date = Date()
            Log.debug("\(date.beats)")
            statusBarButton.title = "\(Int(date.beats))"
        }
    }
    
    // MARK: Timer

    private func startTimer() {
        stopTimer()

        let newTimer = Timer(timeInterval: updateInterval, target: self, selector: #selector(updateInternetTime), userInfo: nil, repeats: true)
        newTimer.tolerance = 0.2
        RunLoop.main.add(newTimer, forMode: .common)

        timer = newTimer

        Log.debug("Manager: Timer Started")
    }

    private func stopTimer() {
        if let existingTimer = timer {
            Log.debug("Manager: Timer Stopped")
            existingTimer.invalidate()
            timer = nil
        }
    }
    
}
