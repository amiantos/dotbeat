//
//  NSDate+Beats.swift
//  NetTime
//
//  Created by Simon Rice on 13/03/2016.
//  Copyright © 2016 Simon Rice. All rights reserved.
//
// https://github.com/SimonRice/NetTime/blob/91c6c680cfd680c1d6a298b91206d2af45ab6d8a/NetTime/Date+Beats.swift

import Foundation

extension Date {
    var beats: Float {
        var components = Calendar.current
            .dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: self)
        components.timeZone = TimeZone(secondsFromGMT: 60 * 60) // BMT == UTC+1
        components.hour = 0
        components.minute = 0
        components.second = 0

        guard let midnight = Calendar.current.date(from: components) else { return 0 }

        let seconds = self.timeIntervalSince(midnight)

        var currentBeats = fmod(Float((seconds / 86400.0) * 1000.0), 1000.0)
        if currentBeats < 0 {
            currentBeats += 1000.0
        }
        return currentBeats
    }

    var nearestBeat: Int {
        return Int(floor(self.beats))
    }
}
