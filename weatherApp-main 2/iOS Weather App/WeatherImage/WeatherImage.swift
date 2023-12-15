//
//  WeatherImage.swift
//  iOS Weather App
//
//  Created by Pawandeep Singh on 06/12/23.
//

import UIKit

// MARK: - Weather Image Helper

// Function to get weather image based on weather code
func getWeatherImage(code: Int) -> UIImage? {
    let config = UIImage.SymbolConfiguration.preferringMulticolor()

    switch code {
    case 1000:
        return UIImage(systemName: "sun.max.fill", withConfiguration: config)
    case 1003:
        return UIImage(systemName: "cloud.sun.fill", withConfiguration: config)
    case 1006, 1030:
        return UIImage(systemName: "cloud.fill")
    case 1009, 1135:
        return UIImage(systemName: "smoke.fill", withConfiguration: config)
    case 1063, 1087, 1150, 1153, 1180, 1183, 1186, 1189, 1192, 1195, 1198, 1201, 1240, 1243, 1246, 1273, 1276:
        return UIImage(systemName: "cloud.bolt.rain.fill", withConfiguration: config)
    case 1066, 1072, 1147, 1168, 1171, 1210, 1213, 1216, 1219, 1222, 1225, 1237, 1255, 1258, 1261, 1264, 1279, 1282:
        return UIImage(systemName: "snowflake")
    default:
        return UIImage(systemName: "questionmark", withConfiguration: config)
    }
}

// MARK: - UIViewController Extension for Alerts

extension UIViewController {
    // Function to display an alert
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
