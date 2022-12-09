//
//  MainViewModel.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    
    var loadingBehaviour = BehaviorRelay<Bool>(value: false)
    var converFromBehavior = BehaviorRelay<String>(value: "")
    var countryCodeSelectedFrom = BehaviorRelay<String>(value: "")
    var countryCodeSelectedTo = BehaviorRelay<String>(value: "")
    var countriesCodeBehaviour = BehaviorRelay<[String]>(value: [])
    var didselectFrom = BehaviorRelay<Bool>(value: false)
    var didSelectTo = BehaviorRelay<Bool>(value: false)
    var enableSwitchBehaviour = BehaviorRelay<Bool>(value: false)
    var symbolKeys = [String]()
    var isCountryFromSelected: Observable<Bool> {
        return countryCodeSelectedFrom.asObservable().map { (country) -> Bool in
            let isSelected = !country.isEmpty
            return isSelected
        }
    }
    
    var isCountryToSelected: Observable<Bool> {
        return countryCodeSelectedTo.asObservable().map { (country) -> Bool in
            let isSelected = !country.isEmpty
            return isSelected
        }
    }
    
    
    var isSwitchButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isCountryFromSelected, isCountryToSelected) { (fromSelected, toSelected) in
            let switchEnabled = fromSelected && toSelected
            return switchEnabled
            
        }
    }

    private var countriesModel = PublishSubject<CountriesSymbol>()
    
    var countriesModelObeservable: Observable<CountriesSymbol> {
        return countriesModel
    }
    
    func fetchAvalibleCurrencies() {
        loadingBehaviour.accept(true)
        var components = URLComponents(string:  NetworkEndpoint.symbols.url)!
        let parameters = ["apikey": APIClient.api_key]
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = components.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPSMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, err in
            self?.loadingBehaviour.accept(false)
            guard let data = data else {return}
            do {
                guard  var data = try? JSONDecoder().decode(CountriesSymbol.self, from: data) else {return}
                print(data.getKeysArra())
                self?.countriesCodeBehaviour.accept(data.getKeysArra())
//                self?.countriesModel.onNext(data)
               
            } catch let parseError {
                print(parseError)
            }
        }
        task.resume()
        
    }
}
