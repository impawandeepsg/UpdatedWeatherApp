//
//  WeatherAPI.swift
//  iOS Weather App
//
//  Created by Pawandeep Singh on 06/12/23.
//

import Foundation

class WeatherAPI {
    
    // MARK: - Singleton
    
    private init() { }
    
    static let shared = WeatherAPI()
    
    // MARK: - API Constants
    
    private static let APIKEY = "b708f52f62fd4cc6acd93153231711"
    
    // MARK: - Base URL
    
    let baseURL = "https://api.weatherapi.com/v1/"
    
    // MARK: - Weather Data Fetching
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (weatherStruct?, Error?) -> () ) {
        guard var url = URLComponents(string: baseURL + "current.json") else { return }
        url.queryItems = [
            URLQueryItem(name: "key", value: WeatherAPI.APIKEY),
            URLQueryItem(name: "q", value: "\(lat),\(lon)")
        ]
        guard let finalURL = url.url?.absoluteURL else { return }
        URLSession.shared.dataTask(with: finalURL, completionHandler: { data, response, error in
            guard let jsonData = data else { return }
            do {
                let weatherResponse = try JSONDecoder().decode(weatherStruct.self, from: jsonData)
                completion(weatherResponse, nil)
            } catch let parseErr {
                print("JSON Parsing Error", parseErr)
                completion(nil, parseErr)
            }
        }).resume()
    }
    
    // MARK: - City Autocomplete
    
    func getCity(name: String, completion: @escaping (CityStruct?, Error?) -> () ) {
        guard var url = URLComponents(string: baseURL + "search.json") else { return }
        url.queryItems = [
            URLQueryItem(name: "key", value: WeatherAPI.APIKEY),
            URLQueryItem(name: "q", value: "\(name)")
        ]
        guard let finalURL = url.url?.absoluteURL else { return }
        URLSession.shared.dataTask(with: finalURL, completionHandler: { data, response, error in
            guard let jsonData = data else { return }
            do {
                let cityResponse = try JSONDecoder().decode(CityStruct.self, from: jsonData)
                completion(cityResponse, nil)
            } catch let parseErr {
                print("JSON Parsing Error", parseErr)
                completion(nil, parseErr)
            }
        }).resume()
    }
}
