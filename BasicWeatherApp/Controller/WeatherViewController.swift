//
//  ViewController.swift
//  BasicWeatherApp
//
//  Created by Jaroslav Janda on 19/06/2019.
//  Copyright © 2019 Jaroslav Janda. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherViewController: UIViewController {
    
    // MARK: - UI
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // MARK: - Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "639321efa312f94d442150666ebd773e"
    let UNITS = "metric"
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

 extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
        
        let params: [String: String] = ["id": APP_ID, "units": UNITS, "lat": String(locValue.latitude), "lac": String(locValue.longitude)]
        getWeatherData(URL: WEATHER_URL, params: params)
    }
}

private extension WeatherViewController {
    func getWeatherData(URL: String, params: [String: String]) {
        
    }
}
