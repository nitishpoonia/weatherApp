//
//  WeatherManager.swift
//  Clima
//
//  Created by Nitish Poonia on 25/01/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=14138ffe51129a6fdfddd0fc1958db9f&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //        1. Create a url
        if let url = URL(string: urlString){
            //            2. Create a session url
            let session = URLSession(configuration: .default)
            //        3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        DispatchQueue.main.async {
                            let weatherVC = WeatherViewController()
                            self.delegate?.didUpdateWeather(weatherManager: self, weather: weather)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(cityName: name, conditinoId: id, temperature: temp)
            return weather
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
    
}
