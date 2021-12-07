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

    @IBAction func sliderChanged(_ sender: NSSlider) {
        let sliderInt = Int(sender.doubleValue)
        let hours = Int(sliderInt / 60)
        let minutes = sliderInt % 60
        
        date = calendar.date(bySettingHour: hours, minute: minutes, second: 0, of: date) ?? date
        
        updateInterface()
        
    }
    
    private var calendar = Calendar.current
    private var date: Date = Date()
    private var dateFormatter: DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.timeStyle = .short
        
        updateInterface()
        
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let minutes = (hour * 60) + minute
        
        timeSlider.doubleValue = Double(minutes)
        
    }
    
    private func updateInterface() {
        localTimeLabel.stringValue = dateFormatter.string(from: date)
        internetTimeLabel.stringValue = "@\(date.nearestBeat)"
        
        PSTTimeLabel.stringValue = dateFormatter.string(from: date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: TimeZone(abbreviation: "PST")!))
        
        CSTTimeLabel.stringValue = dateFormatter.string(from: date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: TimeZone(abbreviation: "CST")!))
        
        MSTTimeLabel.stringValue = dateFormatter.string(from: date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: TimeZone(abbreviation: "MST")!))
        
        ESTTImeLabel.stringValue = dateFormatter.string(from: date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: TimeZone(abbreviation: "EST")!))
    }
    
}
