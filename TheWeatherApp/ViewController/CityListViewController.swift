//
//  ViewController.swift
//  TheWeatherApp
//
//  Created by Dogukan Yolcuoglu on 10.05.2021.
//

import UIKit
import CoreLocation
import MapKit

class CityListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    //MARK: - Variables
    let rowTitle = ["My Location","Nearby city list"]
    let locationManager = CLLocationManager()
    var span = MKCoordinateSpan()
    var region = MKCoordinateRegion()
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var cityListViewModel : CityListViewModel!
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - State func
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        userLocation()
        cityService()
    }
    
    //MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return rowTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityListViewModel == nil ? 0 : cityListViewModel.numberRowInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! MyLocationViewCell
            
            cell.mapView.setRegion(region, animated: true)
            cell.mapView.showsUserLocation = true
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityListViewCell
            
            let cityViewModel = cityListViewModel.cityAtIndex(indexPath.row)
            cell.cityName.text = cityViewModel.cityName
     
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rowTitle[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
    //MARK: - Service func
    
    func cityService() {
        let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(latitude),\(longitude)")!
        
        APIService().downloadCities(url: url) { (cities) in
            
            if let cities = cities {
                
                self.cityListViewModel = CityListViewModel(cityListViewModel: cities)
            }
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    
   //MARK: - Location delegate methods
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       let userLocation :CLLocation = locations[0] as CLLocation
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        
        span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        
   }
    
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("Error : \(error)")
   }
    
    func userLocation(){
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
}

