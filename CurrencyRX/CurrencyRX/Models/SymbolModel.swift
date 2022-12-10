//
//  SymbolModel.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

import Foundation
import RxDataSources

struct CountriesSymbol: Codable {
    let symbols : [String: String]?
    let success: Bool?
    
    mutating func getKeysArra() -> [String] {
        var array = [String]()
       symbols?.compactMap({ key,valu in
            array.append(key)
        })
        return array
    }
    enum CodingKeys: String, CodingKey {
        case success
        case symbols
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbols = try container.decodeIfPresent([String:String].self, forKey: .symbols) ?? [:]
        success = try container.decodeIfPresent(Bool.self, forKey: .success) ?? false
    }
}



struct CovertResult: Codable {
    let success: Bool?
    let result: Double?
    
}


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


struct Transaction: Codable {
    var country: String
    var value: Double
    
    

    
}

struct Rate: Codable {
    let rateCurreny: [String: Double]
}



struct SectionViewModel {
    var header: String
    var items: [Transaction]
}


extension SectionViewModel: SectionModelType {
    typealias Item = Transaction
    
    init(original: SectionViewModel, items: [Transaction]) {
        self = original
        self.items = items
        
    }
}
    
    struct LatestRates: Codable {
        let success: Bool?
        let rates : [String: Double]?
       
    }

    
