//
//  WeatherDetailsViewController.swift
//  TheWeatherApp
//
//  Created by Dogukan Yolcuoglu on 10.05.2021.
//

import UIKit

class WeatherDetailsViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    
    //MARK: - IBOutlets
    
    var weatherListViewModel : WeatherListViewModel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCity : String?
    var selectedWoeid : Int = 0
    
    let dayArray = ["Monday","Thuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    
    var year : Int = 0
    var month : Int = 0
    var day : Int = 0
    var dateConvert : String = ""
    
    //MARK: - State func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        year =  components.year!
        month = components.month!
        day = components.day!
        
        dateConvert = "\(year)/\(month)/\(day)"
        
        if let cityName = selectedCity {
            cityNameLabel.text = "\(cityName.uppercased()) "
        }
        
        weatherService(woeid: selectedWoeid, date: dateConvert)
    }
    
    //MARK: - Tableview Delegate & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListViewModel == nil ? 0 : weatherListViewModel.numberRowInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherListViewCell
        
        let weatherViewModel = weatherListViewModel.weatherAtIndex(indexPath.row)
        cell.weatherStateLabel.text = weatherViewModel.weatherState
        cell.imageview.load(urlString: "https://www.metaweather.com/static/img/weather/png/64/\(weatherViewModel.weatherAbbreviation).png")
        
        cell.dayLabel.text = algorithm(array: dayArray, index: getDayOfWeek(dateConvert)! - 2)[indexPath.row]
        
        
        return cell
    }
    
    //MARK: - Service
    func weatherService(woeid: Int, date: String){
        
        let url = URL(string: "https://www.metaweather.com/api/location/\(woeid)/\(date)/")!
        
        WeatherService().downloadWeathers(url: url) { (weathers) in
            
            if let weathers = weathers {
                
                self.weatherListViewModel = WeatherListViewModel(weatherListViewModel: weathers)
            }
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    //MARK: - Other func
    
    func algorithm<T>(array: Array<T>, index : Int) -> Array<T> {
        var arr = array
        
        for _ in 0..<index{
            let element = arr.remove(at: 0)
            arr.append(element)
        }
        
        return arr
    }
    
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
}

//MARK: - Extension

extension UIImageView {
    func load(urlString : String){
        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data  = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image  = image
                    }
                }
            }
        }
    }
}
