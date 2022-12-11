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

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = MainViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
        
        
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
            result = vale
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

    
    
    func testFetchApi() {
        
    }
    
    func testConvertApi() {
        
    }
}
