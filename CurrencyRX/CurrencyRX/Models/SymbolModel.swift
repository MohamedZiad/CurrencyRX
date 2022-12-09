//
//  SymbolModel.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

import Foundation

//
//class Countries: Codable {
////    var countries: String
//
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        do {
//            countries = try container.decode(String.self)
//        } catch {
//            let tempString = try container.decode(String.self)
//            countries = tempString
//        }
//    }
//}


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
    

