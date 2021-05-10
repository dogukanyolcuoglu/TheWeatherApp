//
//  UserLocationViewCell.swift
//  TheWeatherApp
//
//  Created by Dogukan Yolcuoglu on 10.05.2021.
//

import Foundation
import UIKit

struct CityWeatherViewModel {
    
    let cityViewModel : City
    

    var cityWeatherState : String {
        
        return cityViewModel.weatherState
    }
    
    var cityWeatherIcon : UIImage {
        return cityViewModel.weatherIcon
    }
    
    
}

struct CityWeatherListViewModel {
    
    let cityWeatherListViewModel : [City]
    
    func rowInSection () -> Int {
        return cityWeatherListViewModel.count
    }
    func cityWeatherAtIndex(_ index : Int) -> CityWeatherViewModel {
        
        let cityWeather = self.cityWeatherListViewModel[index]
        
        return CityWeatherViewModel(cityViewModel: cityWeather)
    }
    
}
