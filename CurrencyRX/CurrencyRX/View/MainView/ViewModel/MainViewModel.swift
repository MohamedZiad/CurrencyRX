//
//  MainViewModel.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

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
    var enableDetailBehaviour = BehaviorRelay<Bool>(value: false)
    var errorBehavior = BehaviorRelay<Bool>(value: false)
    var errorMessageBehaviour = BehaviorRelay<String>(value: "")
    var symbolKeys = [String]()
    var resultConverted = BehaviorRelay<Double>(value: 0.0)
    private var countriesModel = PublishSubject<CountriesSymbol>()
    
    
    
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
    var didConvertvalue: Observable<Bool> {
        return resultConverted.asObservable().map { (value) -> Bool in
            let didConvert = value != 0.0
            return didConvert
        }
    }
    var isDetailsButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isCountryFromSelected, isCountryToSelected, didConvertvalue) { (fromSelected, toSelected, converted) in
            let detailsEnabled =  fromSelected && toSelected && converted
            return detailsEnabled
        }
    }
    
    var countriesModelObeservable: Observable<CountriesSymbol> {
        return countriesModel
    }
    
    
    var validateFieldsObservable: Observable<Bool> {
        return Observable.combineLatest(isCountryFromSelected, isCountryToSelected) { [weak self](fromSelected, toSelected) in
            let isValid =  fromSelected && toSelected
            print("isValidValue: \(isValid)")
            self?.errorBehavior.accept(isValid)
            return isValid
        }
    }

    var errorObservable: Observable<Bool> {
        return validateFieldsObservable.asObservable().map { value in
            print("showerror: \(value)")
            let showError = !value
            print("showerror: \(showError)")
            return showError
        }
    }
    
    
    func fetchAvalibleCurrencies() {
        loadingBehaviour.accept(true)
        var components = URLComponents(string:  NetworkEndpoint.symbols.url)!
        let parameters = ["apikey": APIClient.api_key]
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = components.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPSMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, err in
            if let err = err {
                print(err.localizedDescription)
                self?.errorBehavior.accept(true)
                self?.errorMessageBehaviour.accept(err.localizedDescription)
                self?.loadingBehaviour.accept(false)
            } else {
                guard let data = data else {return}
                
                do {
                    var countryData = try JSONDecoder().decode(CountriesSymbol.self, from: data)
                    
                    if countryData.success ?? false {
                        
                        self?.errorBehavior.accept(false)
                        self?.countriesCodeBehaviour.accept(countryData.getKeysArra())
                        self?.loadingBehaviour.accept(false)
                    } else {
                        
                        
                        self?.errorMessageBehaviour.accept("Error in fetching list")
                        self?.errorBehavior.accept(true)
                        self?.loadingBehaviour.accept(false)
                    }
                } catch let parseError {
                    print("Error in fetch:\(parseError.localizedDescription)")
                    self?.errorBehavior.accept(true)
                    self?.errorMessageBehaviour.accept("Error in fetching list")
                    self?.loadingBehaviour.accept(false)
                    
                }
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
            if let err = err {
                print(err.localizedDescription)
                self?.errorBehavior.accept(true)
                self?.errorMessageBehaviour.accept(err.localizedDescription)
                self?.loadingBehaviour.accept(false)
            } else {
                guard let data = data else {return}
                do {
                    let covertData = try JSONDecoder().decode(CovertResult.self, from: data)
                    if covertData.success ?? false {
                        self?.resultConverted.accept(covertData.result ?? 0.0)
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
        }
        task.resume()
        
    }
}
