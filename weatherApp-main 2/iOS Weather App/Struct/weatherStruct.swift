//
//  weatherStruct.swift
//  iOS Weather App
//
//  Created by Pawandeep Singh on 06/12/23.
//

import Foundation


// MARK: - WeatherResponse
struct weatherStruct: Codable {
    let location: Location?
    let current: Current?
}

// MARK: - Current
struct Current: Codable {
    let lastUpdatedEpoch: Double?
    let lastUpdated: String?
    let tempC, tempF: Double?
    let isDay: Double?
    let condition: Condition?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text, icon: String?
    let code: Int?
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String?
    let lat, lon: Double?
    let tzID: String?
    let localtimeEpoch: Int?
    let localtime: String?

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}
