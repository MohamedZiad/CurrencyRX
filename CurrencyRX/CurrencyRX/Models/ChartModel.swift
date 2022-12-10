//
//  ChartModel.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 10/12/2022.
//

import Foundation
struct ChartModel: Identifiable {
    var id = UUID().uuidString
    var data: [ChartResultModel]
}
    
