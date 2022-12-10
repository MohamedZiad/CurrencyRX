//
//  DropDownCell.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//


import UIKit

class DropDownCell: UITableViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    static let starTintColor = UIColor(red: 212/255, green: 163/255, blue: 50/255, alpha: 1.0)
    
    
    
    
    func configureCell(currency: String) {
        currencyLabel.text = currency
    }
}
