//
//  hisotryCell.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 09/12/2022.
//

import Foundation
import UIKit
class HisotryCell: UITableViewCell {
    
    
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyCostLabel: UILabel!
    
    func configureCell(rates: TimeSeries) {
        let rates =  rates.rates.mapValues { dict in
            print(dict)
        }
    }
}
