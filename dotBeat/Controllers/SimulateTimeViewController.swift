//
//  SimulateTimeViewController.swift
//  dotBeat
//
//  Created by Brad Root on 12/6/21.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Cocoa

class SimulateTimeViewController: NSViewController, NSComboBoxDataSource, NSComboBoxDelegate {

    @IBOutlet weak var internetTimeLabel: NSTextField!
    @IBOutlet weak var localTimeLabel: NSTextField!
    @IBOutlet weak var localTimeStepper: NSDatePicker!

    @IBOutlet weak var comboBox: NSComboBox!
    @IBOutlet weak var timeSlider: NSSlider!

    @IBAction func sliderChanged(_ sender: NSSlider) {
        let sliderInt = Int(sender.doubleValue)
        if let newDate = sliderInt.date {
            date = newDate
            updateInterface()
        }

    }
    @IBAction func stepperChanged(_ sender: NSDatePicker) {
        date = sender.dateValue
        updateInterface()
        timeSlider.doubleValue = Double(date.nearestBeat)
    }

    private var calendar = Calendar.current
    private var date: Date = Date()
    private var dateFormatter: DateFormatter = DateFormatter()
    private var timeZoneIdentifiers: [String] = []
    private var filteredTimeZoneIdentifiers: [String] = []

    private var zones: [Zone] = [
        Zone(timeZone: TimeZone(identifier: "Pacific/Honolulu")!, name: "Honolulu"),
        Zone(timeZone: TimeZone(identifier: "America/Anchorage")!, name: "Anchorage"),
        Zone(timeZone: TimeZone(identifier: "America/Los_Angeles")!, name: "Los Angeles"),
        Zone(timeZone: TimeZone(identifier: "America/Phoenix")!, name: "Phoenix"),
        Zone(timeZone: TimeZone(identifier: "America/Chicago")!, name: "Chicago"),
        Zone(timeZone: TimeZone(identifier: "America/New_York")!, name: "New York"),
        Zone(timeZone: TimeZone(identifier: "America/Manaus")!, name: "Manaus"),
        Zone(timeZone: TimeZone(identifier: "America/St_Johns")!, name: "St. John's"),
        Zone(timeZone: TimeZone(identifier: "America/Santiago")!, name: "Santiago"),
        Zone(timeZone: TimeZone(identifier: "America/Sao_Paulo")!, name: "São Paulo"),
        Zone(timeZone: TimeZone(identifier: "Atlantic/South_Georgia")!, name: "South Georgia"),
        Zone(timeZone: TimeZone(identifier: "Atlantic/Cape_Verde")!, name: "Cape Verde"),
        Zone(timeZone: TimeZone(identifier: "Europe/London")!, name: "London"),
        Zone(timeZone: TimeZone(identifier: "Africa/Lagos")!, name: "Lagos"),
        Zone(timeZone: TimeZone(identifier: "Africa/Cairo")!, name: "Cairo"),
        Zone(timeZone: TimeZone(identifier: "Europe/Moscow")!, name: "Moscow"),
        Zone(timeZone: TimeZone(identifier: "Asia/Tehran")!, name: "Tehran"),
        Zone(timeZone: TimeZone(identifier: "Asia/Baku")!, name: "Baku"),
        Zone(timeZone: TimeZone(identifier: "Asia/Kabul")!, name: "Kabul"),
        Zone(timeZone: TimeZone(identifier: "Asia/Karachi")!, name: "Karachi"),
        Zone(timeZone: TimeZone(identifier: "Asia/Calcutta")!, name: "Kolkata"),
        Zone(timeZone: TimeZone(identifier: "Asia/Kathmandu")!, name: "Kathmandu"),
        Zone(timeZone: TimeZone(identifier: "Asia/Dhaka")!, name: "Dhaka"),
        Zone(timeZone: TimeZone(identifier: "Asia/Yangon")!, name: "Yangon"),
        Zone(timeZone: TimeZone(identifier: "Asia/Jakarta")!, name: "Jakarta"),
        Zone(timeZone: TimeZone(identifier: "Asia/Shanghai")!, name: "Shanghai"),
        Zone(timeZone: TimeZone(identifier: "Asia/Tokyo")!, name: "Tokyo"),
        Zone(timeZone: TimeZone(identifier: "Australia/Brisbane")!, name: "Brisbane"),
        Zone(timeZone: TimeZone(identifier: "Australia/Sydney")!, name: "Sydney"),
        Zone(timeZone: TimeZone(identifier: "Asia/Anadyr")!, name: "Anadyr"),
        Zone(timeZone: TimeZone(identifier: "Pacific/Auckland")!, name: "Auckland"),
        Zone(timeZone: TimeZone(identifier: "Pacific/Kiritimati")!, name: "Kiritimati"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.translatesAutoresizingMaskIntoConstraints = false

        self.timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
        self.filteredTimeZoneIdentifiers = timeZoneIdentifiers
        comboBox.usesDataSource = true
        comboBox.dataSource = self
        comboBox.delegate = self

        // Set the user's local timezone
        comboBox.stringValue = TimeZone.current.identifier


        dateFormatter.timeStyle = .short

        updateInterface()

        timeSlider.doubleValue = Double(date.nearestBeat)

        self.view.window?.setFrameOrigin(NSPoint(x: 1, y: 1))

        var index = 0;
        for zone in zones {
            self.view.addSubview(zone.gmtOffsetLabel)
            self.view.addSubview(zone.cityLabel)
            self.view.addSubview(zone.timeLabel)

            zone.gmtOffsetLabel.topAnchor.constraint(equalTo: zone.timeLabel.bottomAnchor, constant: 4).isActive = true
            zone.cityLabel.bottomAnchor.constraint(equalTo: zone.timeLabel.topAnchor, constant: -3).isActive = true


            zone.gmtOffsetLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
            zone.timeLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
            zone.cityLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true

            // Far left items
            if [0, 4, 8, 12, 16, 20, 24, 28, 32].contains(index) {
                zone.gmtOffsetLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                zone.timeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
                zone.cityLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            }

            // Far right items
            if [3, 7, 11, 15, 19, 23, 27, 31].contains(index) {
                zone.gmtOffsetLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                zone.timeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
                zone.cityLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            }

            // Three columns on the right
            if [1, 2, 3, 5, 6, 7, 9, 10, 11, 13, 14, 15, 17, 18, 19, 21, 22, 23, 25, 26, 27, 29, 30, 31].contains(index) {
                zone.gmtOffsetLabel.leadingAnchor.constraint(equalTo: zones[index-1].gmtOffsetLabel.trailingAnchor, constant: 8).isActive = true
                zone.timeLabel.leadingAnchor.constraint(equalTo: zones[index-1].timeLabel.trailingAnchor, constant: 8).isActive = true
                zone.cityLabel.leadingAnchor.constraint(equalTo: zones[index-1].cityLabel.trailingAnchor, constant: 8).isActive = true
            }

            // Top Row Constraints
            if [0, 1, 2, 3].contains(index) {
                zone.cityLabel.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 16).isActive = true
            } else {
                zone.cityLabel.topAnchor.constraint(equalTo: zones[index-4].gmtOffsetLabel.bottomAnchor, constant: 16).isActive = true
            }

            // Bottom row constraints
            if [28, 29, 30, 31].contains(index) {
                zone.gmtOffsetLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            }

            index += 1
        }

    }

    override func viewWillAppear() {
        super.viewWillAppear()
        date = Date()
        timeSlider.doubleValue = Double(date.nearestBeat)
        updateInterface()
    }

    private func updateInterface() {
        localTimeLabel.stringValue = dateFormatter.string(from: date)
        internetTimeLabel.stringValue = "@\(date.nearestBeat)"
        localTimeStepper.dateValue = date

        for zone in zones {
            zone.timeLabel.stringValue = convertToTimezone(timeZone: zone.timeZone)
        }
    }

    private func convertToTimezone(timeZone: TimeZone) -> String {
        return dateFormatter.string(from: date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: timeZone))
    }

    // MARK: - ComboBox Delegate

    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return filteredTimeZoneIdentifiers.count
    }

    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return filteredTimeZoneIdentifiers[index]
    }

    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        return filteredTimeZoneIdentifiers.first { $0.lowercased().hasPrefix(string.lowercased()) }
    }

    func comboBoxWillPopUp(_ notification: Notification) {
        // Reset the filtered list when the combo box is about to be shown
        filteredTimeZoneIdentifiers = timeZoneIdentifiers
        comboBox.reloadData()
    }

    func controlTextDidChange(_ obj: Notification) {
        guard let comboBox = obj.object as? NSComboBox else { return }
        if !comboBox.isExpanded {
            comboBox.isExpanded = true
        }
        let searchText = comboBox.stringValue.lowercased()

        if searchText.isEmpty {
            filteredTimeZoneIdentifiers = timeZoneIdentifiers
        } else {
            filteredTimeZoneIdentifiers = timeZoneIdentifiers.filter { $0.lowercased().contains(searchText) }
        }
        comboBox.reloadData()
    }
    func comboBoxSelectionDidChange(_ notification: Notification) {
        let selectedIndex = comboBox.indexOfSelectedItem
        if selectedIndex >= 0 && selectedIndex < filteredTimeZoneIdentifiers.count {
            let selectedTimeZoneIdentifier = filteredTimeZoneIdentifiers[selectedIndex]
            if let selectedTimeZone = TimeZone(identifier: selectedTimeZoneIdentifier) {
                localTimeStepper.timeZone = selectedTimeZone
            }
        }
    }
}

public extension NSComboBox {
    var isExpanded: Bool {
        set {
            cell?.setAccessibilityExpanded(newValue)
        }
        get {
            return cell?.isAccessibilityExpanded() ?? false
        }
    }
}
