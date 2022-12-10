//
//  APIClient.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

import Foundation
import RxSwift

class APIClient {
        
    
    static let api_key = "MLCrE8Z3iG02346EdLA5Sp1HuEUgAPiN"
    static let baseURL = URL(string: "https://data.fixer.io/api/")!
    static let shared = APIClient()
    
    private init () {
        
    }

    static  func request(baseURL: NetworkEndpoint, parameters: [String: String] = [:], httpsMethod: HTTPSMethod) -> Observable<Result<Data, Error>> {
        //1
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
      
       
        //2
        return Observable.create { observer in
            var components = URLComponents(string: baseURL.url)!
            components.queryItems = parameters.map(URLQueryItem.init)
            
           
            let url = components.url!
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpsMethod.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            var result: Result<Data, Error>?
            dataTask = defaultSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse , response.statusCode == 200 {
                    let printData = String(data: data, encoding: String.Encoding.utf8)
                    print("Pretified\(String(describing: printData))")
                    print("JSONDATA\(data), JSONResponse:\(response)")
                    result = Result<Data, Error>.Success(data)
                } else {
                    if let error = error {
                        result = Result<Data, Error>.Failure(error)
                    }
                }
                observer.onNext(result!)
                observer.onCompleted()
            }
            dataTask?.resume()
            //3
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
}

