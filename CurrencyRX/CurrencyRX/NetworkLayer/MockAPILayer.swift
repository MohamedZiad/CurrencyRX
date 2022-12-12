import UIKit


protocol URLSessionProtocol {
    associatedtype DataTaskType
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> DataTaskType
}



protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    typealias CompletionHandler = URLSessionMock.CompletionHandler

    private let completion: CompletionHandler

    init(completion: @escaping CompletionHandler) {
        self.completion = completion
    }

    func resume() {
        // create some data
        completion(nil, nil, nil)
    }
}

class URLSessionMock: URLSessionProtocol {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    // data and error can be set to provide data or an error
    var data: Data?
    var error: Error?
    func dataTask(with url: URL,completionHandler: @escaping CompletionHandler) -> URLSessionDataTaskMock {
        return URLSessionDataTaskMock(completion: completionHandler)
    }
}
