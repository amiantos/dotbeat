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
    private var cityMap: CityMap = CityMap()

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
        Zone(timeZone: TimeZone(identifier: "Europe/Paris")!, name: "Paris"),
        Zone(timeZone: TimeZone(identifier: "Africa/Cairo")!, name: "Cairo"),
        Zone(timeZone: TimeZone(identifier: "Europe/Moscow")!, name: "Moscow"),
        Zone(timeZone: TimeZone(identifier: "Asia/Tehran")!, name: "Tehran"),
        Zone(timeZone: TimeZone(identifier: "Asia/Baku")!, name: "Baku"),
        Zone(timeZone: TimeZone(identifier: "Asia/Kabul")!, name: "Kabul"),
        Zone(timeZone: TimeZone(identifier: "Asia/Karachi")!, name: "Karachi"),
        Zone(timeZone: TimeZone(identifier: "Asia/Calcutta")!, name: "Calcutta"),
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

        comboBox.usesDataSource = true
        comboBox.dataSource = self
        comboBox.delegate = self

        // Set the user's local timezone
        comboBox.stringValue = "Biel Mean Time"
        if TimeZone(abbreviation: "CET")?.isDaylightSavingTime() ?? false {
            localTimeStepper.timeZone = TimeZone(abbreviation: "WEST")
        } else {
            localTimeStepper.timeZone = TimeZone(abbreviation: "CET")
        }

        var matchFound = false
        for zone in zones {
            if zone.timeZone == TimeZone.current {
                Log.debug("Found matching timezone.")
                matchFound = true
                break
            }
        }
        var gmtMatchFound = false
        if !matchFound {
            for (index, zone) in zones.enumerated() {
                if zone.timeZone.secondsFromGMT() == TimeZone.current.secondsFromGMT() {
                    Log.debug("Found matching GMT offset.")
                    gmtMatchFound = true
                    zones[index] = Zone(timeZone: TimeZone.current, name: "User Timezone")
                    break
                }
            }
        }
        struct Results {
            let zone: Zone
            let index: Int
            let distance: Int
        }
        if !gmtMatchFound {
            var data: [Results] = []
            for (index, zone) in zones.enumerated() {
                data.append(Results(zone: zone, index: index, distance: abs(zone.timeZone.secondsFromGMT()-TimeZone.current.secondsFromGMT())))
            }
            data = data.sorted(by: {($0.distance, $0.index) < ($1.distance, $1.index)})
            if let result = data.first {
                zones[result.index] = Zone(timeZone: TimeZone.current, name: "User Timezone")
            }
        }
        zones.sort(by: {$0.timeZone.secondsFromGMT() < $1.timeZone.secondsFromGMT()})

        dateFormatter.timeStyle = .short

        updateInterface()

        timeSlider.doubleValue = Double(date.nearestBeat)

        self.view.window?.setFrameOrigin(NSPoint(x: 1, y: 1))

        var index = 0;
        for zone in zones {
            self.view.addSubview(zone.highlightLine)
            self.view.addSubview(zone.gmtOffsetLabel)
            self.view.addSubview(zone.cityLabel)
            self.view.addSubview(zone.timeLabel)

            zone.gmtOffsetLabel.topAnchor.constraint(equalTo: zone.timeLabel.bottomAnchor, constant: 4).isActive = true
            zone.cityLabel.bottomAnchor.constraint(equalTo: zone.timeLabel.topAnchor, constant: -3).isActive = true
            
            zone.gmtOffsetLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
            zone.timeLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
            zone.cityLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true

            zone.highlightLine.widthAnchor.constraint(equalToConstant: 120).isActive = true

            // Far left items
            if [0, 4, 8, 12, 16, 20, 24, 28, 32].contains(index) {
                zone.gmtOffsetLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
                zone.timeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
                zone.cityLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
                zone.highlightLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
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
                zone.highlightLine.leadingAnchor.constraint(equalTo: zone.cityLabel.leadingAnchor, constant: -8).isActive = true
            }

            // Top Row Constraints
            if [0, 1, 2, 3].contains(index) {
                zone.cityLabel.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 16).isActive = true
                zone.highlightLine.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 11).isActive = true
            } else {
                zone.cityLabel.topAnchor.constraint(equalTo: zones[index-4].gmtOffsetLabel.bottomAnchor, constant: 16).isActive = true
                zone.highlightLine.topAnchor.constraint(equalTo: zones[index-4].gmtOffsetLabel.bottomAnchor, constant: 11).isActive = true
            }

            // Bottom row constraints
            if [28, 29, 30, 31].contains(index) {
                zone.gmtOffsetLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
                zone.highlightLine.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -15).isActive = true
            } else {
                zone.highlightLine.bottomAnchor.constraint(equalTo: zone.gmtOffsetLabel.bottomAnchor, constant: 5).isActive = true
            }

            [zone.cityLabel, zone.gmtOffsetLabel, zone.timeLabel, zone.highlightLine].forEach { view in
                let clickGesture = CustomRecognizer(target: self, action: #selector(setTimeCity), zone: zone)
                view.addGestureRecognizer(clickGesture)
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

    @objc private func setTimeCity(sender: Any) {
        if let sender = sender as? CustomRecognizer {
            if let foundCity = cityMap.find(zone: sender.zone) {
                if let timeZone = foundCity.timezone, let selectedTimeZone = TimeZone(identifier: timeZone) {
                    localTimeStepper.timeZone = selectedTimeZone
                    comboBox.stringValue = foundCity.stringValue
                }
            }
        }
    }

    private func convertToTimezone(timeZone: TimeZone) -> String {
        return dateFormatter.string(from: date.convertToTimeZone(initTimeZone: TimeZone.current, timeZone: timeZone))
    }

    // MARK: - ComboBox Delegate

    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return cityMap.filteredData.count
    }

    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return cityMap.filteredData[index].stringValue
    }

    func comboBox(_ comboBox: NSComboBox, completedString string: String) -> String? {
        return cityMap.filteredData.first { $0.city.lowercased().hasPrefix(string.lowercased()) }?.stringValue
    }

    func comboBoxWillPopUp(_ notification: Notification) {
        // Reset the filtered list when the combo box is about to be shown
        cityMap.reset()
        comboBox.reloadData()
    }

    func controlTextDidChange(_ obj: Notification) {
        guard let comboBox = obj.object as? NSComboBox else { return }
        if !comboBox.isExpanded {
            comboBox.isExpanded = true
        }
        let searchText = comboBox.stringValue.lowercased()

        if searchText.isEmpty {
            cityMap.reset()
        } else {
            cityMap.search(text: searchText)
        }
        comboBox.reloadData()
    }

    func comboBoxSelectionDidChange(_ notification: Notification) {
        let selectedIndex = comboBox.indexOfSelectedItem
        if selectedIndex >= 0 && selectedIndex < cityMap.filteredData.count {
            let selectedCity = cityMap.filteredData[selectedIndex]
            if let timeZone = selectedCity.timezone, let selectedTimeZone = TimeZone(identifier: timeZone) {
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

class CustomRecognizer: NSClickGestureRecognizer {
    let zone: Zone

    init(target: Any, action: Selector, zone: Zone) {
        self.zone = zone
        super.init(target: target, action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
