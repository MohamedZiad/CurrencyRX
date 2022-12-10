//
//  ChartResultModel.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 10/12/2022.
//

import Foundation

struct ChartResultModel: Identifiable {
    let date: String
    let result: Double
    var id: String { date }
}
