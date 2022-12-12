//
//  EndPoints.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//


import Foundation
enum NetworkEndpoint {
    case symbols
    case convert
    case timeSeries
    case latest
    
    var url: String {
        switch self {
        case .symbols:
            return "https://api.apilayer.com/fixer/symbols"
        case .convert:
               return "https://api.apilayer.com/fixer/convert"
        case .timeSeries:
            return "https://api.apilayer.com/fixer/timeseries"
        case .latest:
            return "https://api.apilayer.com/fixer/latest"
            
        }
    }
}

enum HTTPSMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    
}
