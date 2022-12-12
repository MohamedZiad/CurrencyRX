import UIKit
//
//
//protocol URLSessionProtocol {
//    associatedtype DataTaskType
//    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskType
//}
//
//
//
//protocol URLSessionDataTaskProtocol {
//    func resume()
//}
//
//extension URLSessionDataTask: URLSessionDataTaskProtocol {}
//
//class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
//    typealias CompletionHandler = URLSessionMock.CompletionHandler
//
//    private let completion: CompletionHandler
//
//    init(completion: @escaping CompletionHandler) {
//        self.completion = completion
//    }
//
//    func resume() {
//        // create some data
//        completion(nil, nil, nil)
//    }
//}
//
//class URLSessionMock: URLSessionProtocol {
//    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
//    // data and error can be set to provide data or an error
//    var data: Data?
//    var error: Error?
//    func dataTask(with url: URL,completionHandler: @escaping CompletionHandler) -> URLSessionDataTaskMock {
//        return URLSessionDataTaskMock(completion: completionHandler)
//    }
//}


protocol URLSessionDataTaskProtocol {
  func resume()
  func cancel()
}

protocol URLSessionProtocol {
  func dataTask(with request: URLRequest,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession : URLSessionProtocol{}
extension URLSessionDataTask : URLSessionDataTaskProtocol{}


class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    // To check if this protocol can handle the given request.
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    // Here you return the canonical version of the request but most of the time you pass the orignal one.
    return request
  }

 
      
    override func startLoading() {
      guard let handler = MockURLProtocol.requestHandler else {
        fatalError("Handler is unavailable.")
      }
        
      do {
        // 2. Call handler with received request and capture the tuple of response and data.
        let (response, data) = try handler(request)
        
        // 3. Send received response to the client.
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data = data {
          // 4. Send received data to the client.
          client?.urlProtocol(self, didLoad: data)
        }
        
        // 5. Notify request has been finished.
        client?.urlProtocolDidFinishLoading(self)
      } catch {
        // 6. Notify received error.
        client?.urlProtocol(self, didFailWithError: error)
      }
    }

  override func stopLoading() {
    // This is called if the request gets canceled or completed.
  }
}
