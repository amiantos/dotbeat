//
//  MainMenuController.swift
//  Internet Time
//
//  Created by Brad Root on 12/6/21.
//

import Cocoa

class MainMenuController: NSObject, NSMenuDelegate {
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBOutlet var mainMenu: NSMenu!
    
    private var timer: Timer?
    private var updateInterval: TimeInterval
    
    // MARK: - View Lifecycle
    
    override init() {
        updateInterval = TimeInterval(1)
        
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
