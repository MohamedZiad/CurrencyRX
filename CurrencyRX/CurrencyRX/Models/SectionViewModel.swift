//
//  SectionViewModel.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 10/12/2022.
//

import Foundation
import RxDataSources

struct SectionViewModel {
    var header: String
    var items: [Transaction]
}


extension SectionViewModel: SectionModelType {
    typealias Item = Transaction
    
    init(original: SectionViewModel, items: [Transaction]) {
        self = original
        self.items = items
        
    }
}
