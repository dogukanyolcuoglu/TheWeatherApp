//
//  UserLocationViewCell.swift
//  TheWeatherApp
//
//  Created by Dogukan Yolcuoglu on 10.05.2021.
//

import Foundation
import UIKit

struct WeatherViewModel {
    
    let weatherViewModel : Weather
    
    var weatherState : String {
        return weatherViewModel.weather_state_name
    }
    
    var weatherAbbreviation : String {
        return weatherViewModel.weather_state_abbr
    }
    
}

struct WeatherListViewModel {
    
    let weatherListViewModel : [Weather]
    
    func numberRowInSection () -> Int {
        return 7
    }
    
    func weatherAtIndex(_ index : Int) -> WeatherViewModel {
        
        let weather = self.weatherListViewModel[index]
        
        return WeatherViewModel(weatherViewModel: weather)
    }
}
