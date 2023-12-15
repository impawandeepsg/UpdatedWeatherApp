//
//  CitiesViewController.swift
//  iOS Weather App
//
//  Created by Pawandeep Singh on 06/12/23.
//

import UIKit

class CitiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var citiesTableView: UITableView!
    
    // MARK: - Properties
    var cityLocation = [(lat: Double, lon: Double)]()
    var cityWeatherDetails = [weatherStruct]()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getWeather()
    }
    
    // MARK: - Data Fetching
    
    func getWeather() {
        for city in cityLocation {
            WeatherAPI.shared.getWeather(lat: city.lat, lon: city.lon) { [weak self] weatherData, error in
                DispatchQueue.main.async { [weak self] in
                    guard error == nil,
                          let weatherData = weatherData else { return }
                    self?.cityWeatherDetails.append(weatherData)
                    if self?.cityWeatherDetails.count == self?.cityLocation.count {
                        self?.citiesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - Table View Delegate and Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as? citiesTableViewCell else { return UITableViewCell() }
        let weatherData = cityWeatherDetails[indexPath.row]
        cell.cityDataLabel.text = (weatherData.location?.name ?? "") + " " + "\(weatherData.current?.tempC ?? 0) °C"
        cell.cityDataImage.image = getWeatherImage(code: weatherData.current?.condition?.code ?? 0)
        return cell
    }
}
