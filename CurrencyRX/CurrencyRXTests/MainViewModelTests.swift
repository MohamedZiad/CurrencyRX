//
//  MainViewModelTests.swift
//  CurrencyRXTests
//
//  Created by Mohamed Ziad on 10/12/2022.
//


import XCTest
import RxTest
import RxBlocking
import RxSwift
import RxCocoa


@testable import CurrencyRX

class ViewModelTests: XCTestCase {
    var disposeBag: DisposeBag!
    var viewModel: MainViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var testScheduler: TestScheduler!
    var expectation: XCTestExpectation!
    
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = MainViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
        let configuration = URLSessionConfiguration.default
        let urlSession = URLSession.init(configuration: configuration)
        configuration.protocolClasses = [MockURLProtocol.self]
        viewModel = MainViewModel(urlSession: urlSession)
        
    }

    override func tearDown() {
        disposeBag = nil
        viewModel = nil
        scheduler = nil
        testScheduler = nil
        super.tearDown()
    }
    
    
    func testWhenInitialStateAllButtonsAreDisabled() {
//Switch Button Enabled
        var result = Bool()
        viewModel.isSwitchButtonEnabled.subscribe { vale in
            result = vale
        }.disposed(by: DisposeBag())
        let expected = false
        testScheduler.start()
        XCTAssertEqual(result, expected)
        
//Detail Button Enabled
        var detailResult = Bool()
        viewModel.isDetailsButtonEnabled.subscribe { vale in
            detailResult = vale
        }.disposed(by: DisposeBag())
        let expectedValueDetails =  false
        testScheduler.start()
        XCTAssertEqual(detailResult, expectedValueDetails)
    }
    
    
    
    func testValidateConvertWithoutCountryToValue() {
        let valueFrom = "1.0"
        let countryFromSelected = "EGP"
        viewModel.countryCodeSelectedFrom.accept(countryFromSelected)
        viewModel.converFromBehavior.accept(valueFrom)
        var convertErrorResult = Bool()
        viewModel.errorObservable.subscribe { vale in
            convertErrorResult = vale
        }.disposed(by: DisposeBag())
        let expectedValueNotValid =  true
        testScheduler.start()
        XCTAssertEqual(convertErrorResult, expectedValueNotValid)

    }
    
    
    func testValidateConvertWithoutCountryFromValue() {
        let valueFrom = "1.0"
        let countrySelectedTo = "EGP"
        viewModel.countryCodeSelectedTo.accept(countrySelectedTo)
        viewModel.converFromBehavior.accept(valueFrom)
        var convertErrorResult = Bool()
        viewModel.errorObservable.subscribe { vale in
            convertErrorResult = vale
        }.disposed(by: DisposeBag())
        let expectedValueNotValid =  true
        testScheduler.start()
        XCTAssertEqual(convertErrorResult, expectedValueNotValid)

    }
    
    func testValidateConvertWithAllData() {
        let valueFrom = "1.0"
        let countrySelectedFrom = "EGP"
        let countrySelectedTo = "EUR"
        viewModel.countryCodeSelectedTo.accept(countrySelectedTo)
        viewModel.converFromBehavior.accept(valueFrom)
        viewModel.countryCodeSelectedFrom.accept(countrySelectedFrom)
        var convertErrorResult = Bool()
        viewModel.errorObservable.subscribe { vale in
            convertErrorResult = vale
        }.disposed(by: DisposeBag())
        let expectedShowError =  false
        testScheduler.start()
        XCTAssertEqual(convertErrorResult, expectedShowError)
        
    }
    
    
//    func test_mockfetch () {
//        guard let fetchFailFile = Bundle.main.url(forResource: "FetchSymbolsFailResponse", withExtension: "json"),  let url = URL(string:NetworkEndpoint.symbols.url)  else {return}
//        let fileData = try? Data(contentsOf: fetchFailFile)
//
//
//
//
//        MockURLProtocol.requestHandler = { request in
//            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
//            print(response, fileData)
//            return (response, fileData)
//        }
//
//        viewModel.fetchAvalibleCurrencies { result in
//            switch result {
//            case .Failure(let err):
//                print("Err:\(err)")
//                self.expectation.fulfill()
//            case .Success(let symbo):
//                XCTFail("Success response was not expected.")
//
//            }
//            self.expectation.fulfill()
//        }
//
//    }
   
}
