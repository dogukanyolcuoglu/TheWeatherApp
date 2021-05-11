//
//  CityViewModel.swift
//  TheWeatherApp
//
//  Created by Dogukan Yolcuoglu on 11.05.2021.
//

import Foundation

struct CityViewModel {
    
    let cityViewModel : City
    
    var cityName : String {
        return cityViewModel.title
    }
    var cityWoeid : Int {
        return cityViewModel.woeid
    }
    
}

struct CityListViewModel {
    
    let cityListViewModel : [City]
    
    func numberRowInSection () -> Int {
        return cityListViewModel.count
    }

    func cityAtIndex(_ index : Int) -> CityViewModel {

        let city = self.cityListViewModel[index]

        return CityViewModel(cityViewModel: city)
    }
}
