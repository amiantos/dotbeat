//
//  SimulateTimeViewController.swift
//  Internet Time
//
//  Created by Brad Root on 12/6/21.
//

import Cocoa

class SimulateTimeViewController: NSViewController {

    @IBOutlet weak var internetTimeLabel: NSTextField!
    @IBOutlet weak var localTimeLabel: NSTextField!
    
    @IBOutlet weak var timeSlider: NSSlider!
    
    @IBOutlet weak var PSTTimeLabel: NSTextField!
    @IBOutlet weak var MSTTimeLabel: NSTextField!
    @IBOutlet weak var CSTTimeLabel: NSTextField!
    @IBOutlet weak var ESTTImeLabel: NSTextField!
    @IBOutlet weak var GMT_4Label: NSTextField!
    @IBOutlet weak var GMT_35Label: NSTextField!
    @IBOutlet weak var GMT_3Label: NSTextField!
    @IBOutlet weak var GMT_2Label: NSTextField!
    @IBOutlet weak var GMT_1Label: NSTextField!
    
    @IBAction func sliderChanged(_ sender: NSSlider) {
        let sliderInt = Int(sender.doubleValue)
        if let newDate = sliderInt.date {
            date = newDate
            updateInterface()
        }
        
    }
    
    private var calendar = Calendar.current
    private var date: Date = Date()
    private var dateFormatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .short
        
        updateInterface()

        timeSlider.doubleValue = Double(date.nearestBeat)
        
    }
    
    private func updateInterface() {
        localTimeLabel.stringValue = dateFormatter.string(from: date)
        internetTimeLabel.stringValue = "@\(date.nearestBeat)"
        
        let labelsAndOffsets = [
            (PSTTimeLabel, -8),
            (MSTTimeLabel, -7),
            (CSTTimeLabel, -6),
            (ESTTImeLabel, -5),
            (GMT_4Label, -4),
            (GMT_35Label, -3.5),
            (GMT_3Label, -3),
            (GMT_2Label, -2),
            (GMT_1Label, -1),
        ]
        
        for labelSet in labelsAndOffsets {
            if let label = labelSet.0 {
                label.stringValue = convertToTimezone(hoursFromGMT: labelSet.1)
            }
        }
    }
    
    private func convertToTimezone(hoursFromGMT: Double) -> String {
        return dateFormatter.string(from: date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: TimeZone(secondsFromGMT: Int(60 * 60 * hoursFromGMT))!))
    }
    
}
