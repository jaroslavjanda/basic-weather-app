//
//  WeatherDataModel.swift
//  BasicWeatherApp
//
//  Created by Jaroslav Janda on 19/06/2019.
//  Copyright © 2019 Jaroslav Janda. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let name: String
    let cod: Int
    let main: Main
    let weather: [WeatherDetail]
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "thunderstorm"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower"
            
        case 601...700 :
            return "snow"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "thunderstorm"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy"
            
        case 900...903, 905...1000  :
            return "thunderstorm"
            
        case 903 :
            return "snow"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }
}

struct Main: Decodable {
    let temp: Double
}

struct WeatherDetail: Decodable {
    let description: String
    let id: Int
    let main: String
}
