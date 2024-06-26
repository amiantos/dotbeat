//
//  CityMap.swift
//  dotBeat
//
//  Created by Brad Root on 6/7/24.
//
// cityMap.json is from https://github.com/kevinroberts/city-timezones originally and has been modified to correct errors

import Foundation

struct CityTimeZone: Codable {
    let city: String
    let cityAscii: String
    let country: String
    let province: String
    let timezone: String?

    var stringValue: String {
        var string = "\(city)"
        if !province.isEmpty {
            string += ", \(province)"
        }
        if !country.isEmpty {
            string += ", \(country)"
        }
        return string
    }
}

class CityMap {
    var data: [CityTimeZone] = []
    var filteredData: [CityTimeZone] = []

    init() {
        guard let url = Bundle.main.url(forResource: "cityMap.json", withExtension: nil) else {
            fatalError("Failed to locate cityMap.json in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load cityMap.json from bundle.")
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self.data = try decoder.decode([CityTimeZone].self, from: data)
            self.data = self.data.sorted(by: {$0.city < $1.city})
            self.filteredData = self.data
        } catch{
            print(error)
        }
    }

    func reset() {
        self.filteredData = self.data
    }

    func search(text: String) {
        self.filteredData = self.data.filter { $0.city.lowercased().contains(text) || $0.country.lowercased().contains(text) || $0.province.lowercased().contains(text)}
    }

    func find(identifier: String) -> CityTimeZone? {
        return self.data.filter { $0.timezone == identifier }.first
    }

    func find(zone: Zone) -> CityTimeZone? {
        if let result = self.data.filter({ $0.city == zone.name && $0.timezone == zone.timeZone.identifier}).first {
            return result
        }

        if let result = self.data.filter({$0.timezone == zone.timeZone.identifier}).first {
            return result
        }

        if let result = self.data.filter({$0.province.contains(zone.name)}).first {
            return result
        }

        return nil
    }
}
