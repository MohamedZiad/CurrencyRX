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
    var errorBehavior = BehaviorRelay<Bool>(value: false)
    var errorMessageBehaviour = BehaviorRelay<String>(value: "")
    var symbolKeys = [String]()
    var resultConverted = BehaviorRelay<Double>(value: 0.0)
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
            guard let data = data else {return}
            do {
                guard  var data = try? JSONDecoder().decode(CountriesSymbol.self, from: data) else {return}
                if data.success ?? false {
                    
                    self?.errorBehavior.accept(false)
                    self?.countriesCodeBehaviour.accept(data.getKeysArra())
                    self?.loadingBehaviour.accept(false)
                } else {
                    self?.errorBehavior.accept(true)
                    self?.errorMessageBehaviour.accept("Error in fetching list")
                    self?.loadingBehaviour.accept(false)
                }
            } catch let parseError {
                print("Error in fetch:\(parseError.localizedDescription)")
                self?.errorBehavior.accept(true)
                self?.errorMessageBehaviour.accept("Error in fetching list")
                self?.loadingBehaviour.accept(false)
                
            }
        }
        task.resume()
    }
    
    
    
    func convertCurrencies() {
//        loadingBehaviour.accept(true)
        var components = URLComponents(string:  NetworkEndpoint.convert.url)!
        let parameters = ["apikey": APIClient.api_key, "from": countryCodeSelectedFrom.value, "to": countryCodeSelectedTo.value, "amount":converFromBehavior.value]
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = components.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPSMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, err in
            guard let data = data else {return}
            do {
                guard  var data = try? JSONDecoder().decode(CovertResult.self, from: data) else {return}
                if data.success ?? false {
                    self?.resultConverted.accept(data.result ?? 0.0)
                    self?.errorBehavior.accept(false)
                } else {
                    self?.errorBehavior.accept(true)
                    self?.errorMessageBehaviour.accept("Error in converting")
                }
               
            } catch let parseError {
                print("Error in Convert:\(parseError.localizedDescription)")
                print(parseError)
            }
        }
        task.resume()
        
    }
}
