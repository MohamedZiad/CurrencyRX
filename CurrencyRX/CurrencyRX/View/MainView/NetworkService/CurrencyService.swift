//
//  CurrencyService.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

import Foundation
import RxSwift

 
protocol CurrencyServiceProtocol {
       func fetchAvalibleCurrencies() -> Observable<CountriesSymbol>
}

class CurrencyService: CurrencyServiceProtocol {
    func fetchAvalibleCurrencies() -> Observable<CountriesSymbol> {
        return Observable.create { observer -> Disposable in
            var components = URLComponents(string:  NetworkEndpoint.symbols.url)!
            let parameters = ["apikey": APIClient.api_key]
            components.queryItems = parameters.map(URLQueryItem.init)
            let url = components.url!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPSMethod.GET.rawValue
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, err in
                guard let data = data else {return}
                do {
                    guard  let data = try? JSONDecoder().decode(CountriesSymbol.self, from: data) else {return}
                    observer.onNext(data)
                } catch {
                    observer.onError(NSError(domain: "", code: -1))
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
