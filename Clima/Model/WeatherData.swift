//
//  WeatherData.swift
//  Clima
//
//  Created by Nitish Poonia on 26/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//
//weather[0].description
import Foundation
struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let description: String
    let id: Int
}
