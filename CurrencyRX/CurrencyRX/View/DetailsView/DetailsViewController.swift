//
//  DetailsViewController.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 09/12/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Charts
import SwiftUI

class DetailsViewController: UIViewController {
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var latestTableView: UITableView!
    
    var selectedFromCurrency: String? = ""
    var selectedToCurrnecy: String? = ""
    var latestSymbols: [String] = []
    private let disposeBag = DisposeBag()
    let detailsViewModel = DetailsViewModel()
    var chartModel = ChartModel(data: [])
    var tranarray: [ChartResultModel] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        detailsViewModel.getDate()
        bindHistoryTableView()
        bindLatestTableView()

    }
    override func viewDidAppear(_ animated: Bool) {
        detailsViewModel.fetchLatest()
        detailsViewModel.fetchDetails()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
        
    }

    private func getDetails() {
        detailsViewModel.fromBehaviour.accept(selectedFromCurrency ?? "")
        detailsViewModel.latestSymbolsBehaviour.accept(latestSymbols.suffix(10))
        detailsViewModel.toSymbolBehaviour.accept(selectedToCurrnecy ?? "")
        titleLabel.text = detailsViewModel.fromBehaviour.value
    }
    
    func bindHistoryTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionViewModel> { _, tableview, index, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: "historyCell", for: index) as! HisotryCell
            cell.currencyCostLabel.text = item.value.roundToDecimal(3).removeZerosFromEnd()
            cell.currencyNameLabel.text = item.country
            return cell
        } titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].header
        }
        
        self.detailsViewModel.detailsModelObeservable
            .map({ series in
                var tranarray: [SectionViewModel] = []
                for single in series.rates {
                    tranarray.append(SectionViewModel(header: single.key, items: single.value))
                }
                return tranarray
            })
            .bind(to: self.historyTableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    func bindLatestTableView() {
        detailsViewModel.latestSymbols
            .map({$0.rates ?? [:]})
            .bind(to: latestTableView.rx.items(cellIdentifier: "othersCell", cellType: OtherCurrenciesCell.self)) { row, model, cell in
                cell.currencyNameLabel.text = model.value.roundToDecimal(3).removeZerosFromEnd()
                cell.currencyLabel.text = model.key
        }.disposed(by: disposeBag)
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: detailsViewModel.errorMessageBehaviour.value, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { [weak self]_ in
            self?.detailsViewModel.errorBehavior.accept(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

