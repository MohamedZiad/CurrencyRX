//
//  MainViewModelTests.swift
//  CurrencyRXTests
//
//  Created by Mohamed Ziad on 10/12/2022.
//


import XCTest
import RxSwift
import RxTest
import RxBlocking


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
        let isSwitchEnabled = testScheduler.createObserver(Bool.self)
       
        viewModel.enableSwitchBehaviour
            .bind(to: isSwitchEnabled)
            .disposed(by: DisposeBag())
        XCTAssertRecordedElements(isSwitchEnabled.events, [false])
    }
    
}
