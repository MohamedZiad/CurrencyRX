//
//  Result.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

import Foundation

enum Result<T, Error> {
    case Success(T)
    case Failure(Error)
}

enum SymbolRequestError: Error {
    case unknown
    case emptyResponse
}
