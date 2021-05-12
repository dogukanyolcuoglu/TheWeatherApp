//
//  Service.swift
//  TheWeatherApp
//
//  Created by Dogukan Yolcuoglu on 10.05.2021.
//

import Foundation

struct CityService {
    
    func downloadCities(url: URL, completion: @escaping ([City]?) -> Void ) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                completion(nil)
                
            } else if let data = data {
                
                let cityList = try? JSONDecoder().decode([City].self, from: data)
  
                if let cityList = cityList {
                    
                    completion(cityList)
                }
            }
        }.resume()
    }
}

struct WeatherService {
    func downloadWeathers(url: URL, completion: @escaping ([Weather]?) -> Void ) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                
            } else if let data = data {
            
                
                let weatherList = try? JSONDecoder().decode([Weather].self, from: data)
                
                
                if let weatherList = weatherList {
                    
                    completion(weatherList)
                }
            }
        }.resume()
    }
}
