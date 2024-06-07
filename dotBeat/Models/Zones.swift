//
//  Zones.swift
//  dotBeat
//
//  Created by Brad Root on 12/7/21.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import AppKit

class Zone {
    public var timeZone: TimeZone
    public var gmtOffsetLabel: NSTextField
    public var cityLabel: NSTextField
    public var timeLabel: NSTextField
    public var name: String
    public var highlightLine: NSBox

    init(timeZone: TimeZone, name: String) {
        self.timeZone = timeZone
        self.name = name
        
        let gmtOffset = Double(timeZone.secondsFromGMT())/60.0/60.0
        let stringOffset = gmtOffset < 0 ? "GMT\(gmtOffset.clean)" : "GMT+\(gmtOffset.clean)"
        gmtOffsetLabel = NSTextField(labelWithString: stringOffset)
        gmtOffsetLabel.translatesAutoresizingMaskIntoConstraints = false
        gmtOffsetLabel.textColor = .tertiaryLabelColor
        gmtOffsetLabel.font = NSFont.systemFont(ofSize: 11)

        cityLabel = NSTextField(labelWithString: name)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textColor = .secondaryLabelColor
        
        timeLabel = NSTextField(labelWithString: "12:00 PM")
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .labelColor
        timeLabel.font = NSFont.systemFont(ofSize: 18)


        highlightLine = NSBox()
        highlightLine.titlePosition = .noTitle
        highlightLine.frame = NSRect(x: 20, y: 20, width: 115, height: 100)
        highlightLine.translatesAutoresizingMaskIntoConstraints = false
        highlightLine.isHidden = true

        if timeZone.identifier == TimeZone.current.identifier {
            highlightLine.isHidden = false
        }

    }
}

extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }

}
