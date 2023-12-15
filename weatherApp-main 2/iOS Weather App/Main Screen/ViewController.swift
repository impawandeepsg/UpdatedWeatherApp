//
//  ViewController.swift
//  iOS Weather App
//
//  Created by Pawandeep Singh on 06/12/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var citySearch: UISearchBar!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    @IBOutlet weak var searchResults: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var TempLabel: UILabel!
    
    // MARK: - Properties
    var locationManager: CLLocationManager?
    var weatherData: weatherStruct?
    private var lastSearchText = ""
    var cityData: CityStruct?
    
    var cityLocation = [(lat: Double, lon: Double)]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        // Set table view delegate and data source
        searchResults.delegate = self
        searchResults.dataSource = self
        searchResults.backgroundColor = .clear
    }
    
    // Hide keyboard on search button click
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Actions
    @IBAction func unitsChanged(_ sender: Any) {
        // Handle temperature unit switch
        guard let segmentContol = sender as? UISegmentedControl,
              let weatherData = weatherData else { return }
        if segmentContol.selectedSegmentIndex == 0 {
            self.TempLabel.text = "\(weatherData.current?.tempC ?? 0)"
        } else {
            self.TempLabel.text = "\(weatherData.current?.tempF ?? 0)"
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass selected city coordinates to CitiesViewController
        if segue.identifier == "Cities" {
            guard let vc = segue.destination as? CitiesViewController else { return }
            vc.cityLocation = cityLocation
        }
    }
    
    // MARK: - Current Location Button Action
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        // Request location authorization and fetch weather data for current location
        locationManager?.requestAlwaysAuthorization()
        guard let latitude = locationManager?.location?.coordinate.latitude,
              let longitude = locationManager?.location?.coordinate.longitude else { return }
        WeatherAPI.shared.getWeather(lat: latitude, lon: longitude) { [unowned self] weatherData, error in
            guard error == nil,
                  let weatherData = weatherData else { return }
            self.weatherData = weatherData
            self.updateUI(weatherData)
            self.cityLocation.append((lat: latitude, lon: longitude))
        }
    }
    
    // MARK: - Update UI with Weather Data
    func updateUI(_ weatherData: weatherStruct) {
        DispatchQueue.main.async { [unowned self] in
            self.weatherConditionLabel.text = weatherData.current?.condition?.text ?? ""
            self.TempLabel.text = "\(weatherData.current?.tempC ?? 0)"
            self.cityLabel.text = weatherData.location?.name ?? ""
            self.weatherConditionImage.image = getWeatherImage(code: weatherData.current?.condition?.code ?? 0)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate { }

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    // Handle search bar text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResults.isHidden = searchText.isEmpty
        if lastSearchText.isEmpty {
            lastSearchText = searchText
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.makeNetworkCall), object: lastSearchText)
        lastSearchText = searchText
        self.perform(#selector(self.makeNetworkCall), with: searchText, afterDelay: 0.9)
    }
        
    // Make network call for city autocomplete after a delay
    @objc private func makeNetworkCall(sender: String) {
        WeatherAPI.shared.getCity(name: lastSearchText) { cityList, error in
            guard error == nil,
                  let cityList = cityList else { return }
            DispatchQueue.main.async {
                self.cityData?.removeAll()
                self.cityData = cityList
                self.searchResults.isHidden = cityList.count == 0
                self.searchResults.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityData?.count ?? 0
    }
    
    // Create cells for each city in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let city = cityData?[indexPath.row].name ?? ""
        let country = cityData?[indexPath.row].country ?? ""
        cell.cityNameLabel.text =  city + " " + country
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    // Handle selection of a city in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cityData?[indexPath.row]
        guard let cityName = selectedCity?.name else { return }
        
        cityLocation.append((lat: selectedCity?.lat ?? 0, lon: selectedCity?.lon ?? 0))
        alert(message: "\(cityName) Added to City List")
        
        WeatherAPI.shared.getWeather(lat: selectedCity?.lat ?? 0, lon: selectedCity?.lon ?? 0) { [weak self] weatherData, error in
            guard error == nil,
                  let weatherData = weatherData else { return }
            self?.weatherData = weatherData
            self?.updateUI(weatherData)
        }
    }
}
