//
//  TimeSeries.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 10/12/2022.
//

import Foundation
struct TimeSeries: Codable {
    let success: Bool
    var rates: [String: [Transaction]]
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rates = [:]
        if let rates = try container.decodeIfPresent([String: [String: Double]].self, forKey: .rates) {
            for rate in rates {
                self.rates[rate.key] = rate.value.map({Transaction(country: $0.key, value: $0.value)})
            }
        }
        success  = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
    }
}
