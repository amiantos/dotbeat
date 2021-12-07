//
//  Int+Beats.swift
//  NetTime
//
//  Created by Simon Rice on 13/03/2016.
//  Copyright © 2016 Simon Rice. All rights reserved.
//
// https://github.com/SimonRice/NetTime/blob/91c6c680cfd680c1d6a298b91206d2af45ab6d8a/NetTime/Int+Beats.swift

import Foundation

extension Int {
    var beats: DateComponents {
        var dateComponents = DateComponents()
        let totalBeats: Float = Float(self) * 86.4
        dateComponents.second = Int(floor(totalBeats))
        dateComponents.nanosecond = Int((totalBeats - floor(totalBeats)) * 10.0) * 100 * 1000 * 1000
        return dateComponents
    }
    
    var date: Date? {
        var components = Calendar.current
            .dateComponents([.timeZone, .year, .month, .day, .hour, .minute, .second], from: Date())
        components.timeZone = TimeZone(secondsFromGMT: 60 * 60) // BMT == UTC+1
        components.hour = 0
        components.minute = 0
        components.second = 0

        guard let midnight = Calendar.current.date(from: components) else { return nil }

        let seconds = Double(self) * 86.4;
        
        return midnight.addingTimeInterval(seconds)
        
    }
}
