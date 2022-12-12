//
//  LatestRates.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 10/12/2022.
//

import Foundation
struct LatestRates: Codable {
    let success: Bool?
    let rates : [String: Double]?
   
}
