//
//  CityListViewCell.swift
//  TheWeatherApp
//
//  Created by Dogukan Yolcuoglu on 10.05.2021.
//

import UIKit

class CityListViewCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet weak var cityNameLabel: UILabel!
    
    
    //MARK: - State func
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
