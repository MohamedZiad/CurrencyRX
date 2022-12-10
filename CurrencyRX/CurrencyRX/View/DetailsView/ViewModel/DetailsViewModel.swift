//
//  DetailsViewModel.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 09/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class DetailsViewModel {
    var loadingBehaviour = BehaviorRelay<Bool>(value: false)
    var errorBehavior = BehaviorRelay<Bool>(value: false)
    var errorMessageBehaviour = BehaviorRelay<String>(value: "")
    var fromBehaviour = BehaviorRelay<String>(value: "")
    var startDateBehaviour = BehaviorRelay<String>(value: "")
    var endDateBehaviour = BehaviorRelay<String>(value: "")
    var latestSymbolsBehaviour =  BehaviorRelay<[String]>(value: [])
    var latestSymbols = PublishSubject<LatestRates>()
    var toSymbolBehaviour = BehaviorRelay<String>(value: "")
    private var detailsModel = PublishSubject<TimeSeries>()
    
    var detailsModelObeservable: Observable<TimeSeries> {
        return detailsModel
    }
    
    
    func fetchDetails() {
        loadingBehaviour.accept(true)
        var components = URLComponents(string:  NetworkEndpoint.timeSeries.url)!
        let parameters = ["apikey": APIClient.api_key, "base":fromBehaviour.value, "start_date":startDateBehaviour.value,"end_date": endDateBehaviour.value, "symbols": toSymbolBehaviour.value]
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = components.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPSMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, err in
            guard let data = data else {return}
            do {
                guard  let data = try? JSONDecoder().decode(TimeSeries.self, from: data) else {return}
                if data.success {
                    self?.errorBehavior.accept(false)
                    self?.loadingBehaviour.accept(false)
                    self?.detailsModel.onNext(data)
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
    
    func getDate() {
        let todaydate = Date()
        let fomatter = DateFormatter()
        fomatter.dateFormat = "yyyy-MM-dd"
        let startDate = fomatter.string(from: todaydate)
        guard let monthAgo = Calendar.current.date(byAdding: .day, value: -30, to: todaydate) else { return }
        let endDate = fomatter.string(from: monthAgo)
        endDateBehaviour.accept(startDate)
        startDateBehaviour.accept(endDate)
    }
    
    func fetchLatest() {
        loadingBehaviour.accept(true)
        var components = URLComponents(string:  NetworkEndpoint.latest.url)!
        let parameters = ["apikey": APIClient.api_key, "base":fromBehaviour.value, "symbols": latestSymbolsBehaviour.value.joined(separator: ",")]
        components.queryItems = parameters.map(URLQueryItem.init)
        let url = components.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPSMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: urlRequest) {[weak self] data, response, err in
            
            guard let data = data else {return}
            do {
                guard  let data = try? JSONDecoder().decode(LatestRates.self, from: data) else {return}
                if data.success ?? false {
                    self?.errorBehavior.accept(false)
                    self?.loadingBehaviour.accept(false)
                    self?.latestSymbols.onNext(data)
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
    
}
