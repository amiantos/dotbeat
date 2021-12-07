//
//  Zones.swift
//  Internet Time
//
//  Created by Brad Root on 12/7/21.
//

import Foundation
import AppKit

class Zone {
    public var timeZone: TimeZone
    public var gmtOffsetLabel: NSTextField
    public var cityLabel: NSTextField
    public var timeLabel: NSTextField
    public var name: String
    
    init(timeZone: TimeZone, name: String) {
        self.timeZone = timeZone
        self.name = name
        
        gmtOffsetLabel = NSTextField(labelWithString: "GMT \(Double(timeZone.secondsFromGMT())/60.0/60.0)")
        gmtOffsetLabel.translatesAutoresizingMaskIntoConstraints = false
        gmtOffsetLabel.textColor = .tertiaryLabelColor
        
        
        cityLabel = NSTextField(labelWithString: self.name)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textColor = .secondaryLabelColor
        
        timeLabel = NSTextField(labelWithString: "12:00 PM")
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .labelColor
        timeLabel.font = NSFont.systemFont(ofSize: 18)
        
    
    }
}
