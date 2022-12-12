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
        symbols?.compactMap({ key,_ in
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
