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
        
        let gmtOffset = Double(timeZone.secondsFromGMT())/60.0/60.0
        let stringOffset = gmtOffset < 0 ? "GMT\(gmtOffset.clean)" : "GMT+\(gmtOffset.clean)"
        gmtOffsetLabel = NSTextField(labelWithString: stringOffset)
        gmtOffsetLabel.translatesAutoresizingMaskIntoConstraints = false
        gmtOffsetLabel.textColor = .tertiaryLabelColor
        gmtOffsetLabel.font = NSFont.systemFont(ofSize: 11)
        
        var nameString = timeZone.localizedName(for: .generic, locale: Locale.current) ?? self.name
        nameString = nameString.replacingOccurrences(of: " Standard", with: "")
        nameString = nameString.replacingOccurrences(of: " Time", with: "")
        cityLabel = NSTextField(labelWithString: nameString)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textColor = .secondaryLabelColor
        
        timeLabel = NSTextField(labelWithString: "12:00 PM")
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .labelColor
        timeLabel.font = NSFont.systemFont(ofSize: 18)
        
    
    }
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }

}
