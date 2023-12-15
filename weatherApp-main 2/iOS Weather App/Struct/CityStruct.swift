//
//  CityStruct.swift
//  iOS Weather App
//
//  Created by Pawandeep Singh on 06/12/23.
//

import Foundation

// MARK: - CityResponseElement
struct CityResponseElement: Codable {
    let id: Int?
    let name, region, country: String?
    let lat, lon: Double?
    let url: String?
}

typealias CityStruct = [CityResponseElement]
