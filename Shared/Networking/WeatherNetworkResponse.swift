//
//  WeatherNetworkResponse.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 5/16/21.
//

import Foundation

struct WeeklyForecastResponse: Codable {
    let list: [Item]
    
    struct Item: Codable {
        let date: Date
        let main: MainClass
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main
            case weather
        }
    }
    
    struct MainClass: Codable {
        let temp: Double
    }
    
    struct Weather: Codable {
        let main: MainEnum
        let weatherDescription: String
        
        enum CodingKeys: String, CodingKey {
            case main
            case weatherDescription = "description"
        }
    }
    
    enum MainEnum: String, Codable {
        case clear = "Clear"
        case clouds = "Clouds"
        case rain = "Rain"
    }
    
}



struct CurrentWeatherForecastResponse: Codable {
    let coord: Coord
    let main: Main
    
    struct Main: Codable {
        let temperature: Double
        let humidity: Int
        let maxTemperature: Double
        let minTemperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case humidity
            case maxTemperature = "temp_max"
            case minTemperature = "temp_min"
        }
    }
    
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }
}

struct OneWeatherAPIResponse: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: CurrentWeather
    
    struct CurrentWeather: Codable {
        let currenttime: Date
        let sunrise: Date
        let sunset: Date
        let temperature: Double
        let feelslike: Double
        let pressure: Int
        let humidity: Int
        let weather: [Weather]
        
        enum CodingKeys: String, CodingKey {
            case currenttime="dt"
            case sunrise
            case sunset
            case temperature = "temp"
            case feelslike = "feels_like"
            case pressure
            case humidity
            case weather = "weather"
        }
    }
    
//    struct Coord: Codable {
//        let lon: Double
//        let lat: Double
//    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
}
