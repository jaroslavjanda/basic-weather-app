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
    let APP_ID = "b3ec72ce3b4cd5378dea6c8b27272bfa"
    let UNITS = "metric"
    
    var locationManager = CLLocationManager()
    
    var cityNameByUser: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //weatherIcon.loadGif(name: "loading")
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.requestWhenInUseAuthorization()
            
            let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.notDetermined
            {
                locationManager.requestAlwaysAuthorization()
            }
            else {
                
                print("locationServices disenabled")
            }
            locationManager.startUpdatingLocation()
        
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        upSwipe.direction = .up
        downSwipe.direction = .down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(upSwipe)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
        performSegue(withIdentifier: "showChangeCity", sender: self)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
        }
        
        let params: [String: String] = ["appid": APP_ID, "units": UNITS, "lat": String(locValue.latitude), "lon": String(locValue.longitude)]
        getWeatherData(URL: WEATHER_URL, params: params)
    }
}

private extension WeatherViewController {
    
    func getWeatherData(URL: String, params: [String: String]) {
        Alamofire.request(URL, method: .get, parameters: params).responseJSON {
            response in
            print(response.result.debugDescription)
            if response.result.isSuccess {
                
                guard let data = response.data else {
                    print("Error: No data to decode")
                    return
                }
                
                guard let weather = try? JSONDecoder().decode(Weather.self, from: data ) else {
                    print("Error: Couldn't decode data into Weather")
                    return
                }
                self.updateUI(weather: weather)
            }
            else {
                print("Error in reponse")
            }
        }
    }
    
    func updateUI(weather: Weather) {
        print(weather)
        cityLabel.text = weather.name
        weatherLabel.text = weather.weather[0].main
        temperatureLabel.text = "\(String(Int(weather.main.temp.rounded())))°C"
        weatherIcon.image = UIImage(named: weather.updateWeatherIcon(condition: weather.weather[0].id))
    }
}

extension WeatherViewController: ChangeCityDelegate {
    func userEnteredNewCity(city: String) {
        cityNameByUser = city
        let params: [String: String] = ["appid": APP_ID, "units": UNITS, "q": city]
        getWeatherData(URL: WEATHER_URL, params: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChangeCity"{
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
            
        }
        
    }
}
