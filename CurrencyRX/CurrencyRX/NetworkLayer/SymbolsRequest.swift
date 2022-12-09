//
//  SymbolsRequest.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

import Foundation
import Foundation
import Foundation

class SymbolsRequest: APIRequest {
    var method = RequestType.GET
    var path = "symbols"
    var parameters = [String: String]()

    init(apiKey: String) {
        parameters["access_key"] = apiKey
    }
}
