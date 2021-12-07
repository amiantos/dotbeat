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
}
