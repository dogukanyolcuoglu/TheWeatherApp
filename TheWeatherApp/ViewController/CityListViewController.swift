//
//  ViewController.swift
//  TheWeatherApp
//
//  Created by Dogukan Yolcuoglu on 10.05.2021.
//

import UIKit
import CoreLocation
import MapKit

class CityListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {

    //MARK: - Variables
    let rowTitle = "Nearby city list"
    var chosenCity = ""
    var chosenWoeid = 0
    let locationManager = CLLocationManager()
    
    var cityListViewModel : CityListViewModel!
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - State func
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        userLocation()
        self.tableView.tableFooterView = UIView()
    }
    
    //MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityListViewModel == nil ? 0 : cityListViewModel.numberRowInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell") as! CityListViewCell
        
        let cityViewModel = cityListViewModel.cityAtIndex(indexPath.row)
        cell.cityNameLabel.text = cityViewModel.cityName
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rowTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityViewModel = cityListViewModel.cityAtIndex(indexPath.row)
        chosenCity = cityViewModel.cityName
        chosenWoeid = cityViewModel.cityWoeid
        performSegue(withIdentifier: "toDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            
            let destination = segue.destination as! WeatherDetailsViewController
            destination.selectedCity = chosenCity
            destination.selectedWoeid = chosenWoeid
        
        }
    }
    
    //MARK: - Service func
    
    func cityService(latitude: Double , longitude: Double) {
    
        let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(latitude),\(longitude)")!
        
        CityService().downloadCities(url: url) { (cities) in
            
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
        
    let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
    
    let latitude = location.latitude
    let longitude = location.longitude
    
    cityService(latitude: latitude, longitude: longitude)
    
    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
    let region = MKCoordinateRegion(center: location, span: span)
    
    mapView.setRegion(region, animated: true)

   }
    
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       print("Error : \(error)")
   }
    
    func userLocation(){
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
}

