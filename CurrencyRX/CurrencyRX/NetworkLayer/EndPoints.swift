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
    
    
    var url: String {
        switch self {
        case .symbols:
            return "https://api.apilayer.com/fixer/symbols"
        case .convert:
               return "https://api.apilayer.com/fixer/convert"
        }
    }
}

enum HTTPSMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    
}
