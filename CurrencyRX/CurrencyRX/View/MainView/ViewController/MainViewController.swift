//
//  ViewController.swift
//  CurrencyRX
//
//  Created by Mohamed Ziad on 08/12/2022.
//

import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var convertedTolabel: UILabel!
    @IBOutlet weak var converTextField: UITextField!
    @IBOutlet weak var dropDownTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    private let disposeBag = DisposeBag()
    let mainViewModel = MainViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindLoadingView()
        bindTableView()
        subscribeToTableViewDidSelect()
        subscribeToSelectedToCountry()
        subscribeToSelectedFromCountry()
        subscribeTodisableSwitch()
        subscribeToSwitchButton()
        subscribeToConvertTextField()
        subscribetToConvertCurrency()
        subscribeToResultLabel()
        subscribeToError()
        subscribeTodisableDetails()
        didTapOnDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainViewModel.fetchAvalibleCurrencies()
    }
    
  private  func bindLoadingView() {
        mainViewModel.loadingBehaviour.observe(on: MainScheduler.instance).subscribe(onNext: { isLoading in
            if isLoading {
                self.loadingView.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.loadingView.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeToSelectedToCountry() {
        toButton.rx.tap.subscribe { [weak self](_) in
            self?.mainViewModel.didSelectTo.accept(true)
            self?.mainViewModel.didselectFrom.accept(false)
            self?.dropDownTableView.isHidden.toggle()
        }.disposed(by: disposeBag)
        
    }
    
    private func subscribeTodisableDetails() {
        mainViewModel.isDetailsButtonEnabled.bind(to: detailsButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func didTapOnDetails() {
        detailsButton.rx.tap.subscribe { [weak self] (_) in
            print("Navigating")
            self?.navigateToDetailsView()
        }
        .disposed(by: disposeBag)
    }
    
    private func subscribeToSelectedFromCountry() {
        fromButton.rx.tap.subscribe { [weak self](_) in
            self?.dropDownTableView.isHidden.toggle()
            self?.mainViewModel.didSelectTo.accept(false)
            self?.mainViewModel.didselectFrom.accept(true)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToResultLabel() {
        mainViewModel.resultConverted
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self]value in
                self?.convertedTolabel.text =  value.element?.roundToDecimal(3).removeZerosFromEnd()
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeToSwitchButton() {
        switchButton.rx.tap.subscribe { [weak self](_) in
            self?.mainViewModel.countryCodeSelectedFrom.accept(self?.toLabel.text ?? "")
            self?.mainViewModel.countryCodeSelectedTo.accept(self?.fromLabel.text ?? "")
            self?.toLabel.text = self?.mainViewModel.countryCodeSelectedTo.value
            self?.fromLabel.text = self?.mainViewModel.countryCodeSelectedFrom.value
            if !(self?.mainViewModel.converFromBehavior.value.isEmpty ?? false) {
                self?.mainViewModel.convertCurrencies()
            }
        }.disposed(by: disposeBag)
    }
    
    private func subscribeTodisableSwitch() {
        mainViewModel.isSwitchButtonEnabled.bind(to: switchButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func subscribeToConvertTextField() {
        converTextField.rx.text.orEmpty.bind(to: mainViewModel.converFromBehavior)
            .disposed(by: disposeBag)
    }
    
    private func subscribetToConvertCurrency() {
        converTextField.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged()
            .throttle(RxTimeInterval.microseconds(500), scheduler: MainScheduler.instance)
            .subscribe {[weak self ] value in
                guard let self = self else {return}
                if self.mainViewModel.countryCodeSelectedFrom.value.isEmpty && self.mainViewModel.countryCodeSelectedTo.value.isEmpty {
                    self.mainViewModel.errorMessageBehaviour.accept("Please select country to convert")
                    self.mainViewModel.errorBehavior.accept(true)
                } else if !(value.element?.isEmpty ?? false) && value.element != "0" {
                    self.mainViewModel.convertCurrencies()
                }
            }.disposed(by: disposeBag)
    }
    
    
    private func bindTableView() {
        mainViewModel.countriesCodeBehaviour.bind(to: dropDownTableView.rx.items(cellIdentifier: "CellIdentifier", cellType: DropDownCell.self)) { row, model, cell in
            cell.configureCell(currency: model)
        }.disposed(by: disposeBag)
        print(mainViewModel.countriesCodeBehaviour.value.count)
    }
    
    func subscribeToError() {
        mainViewModel.errorBehavior
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] error in
                if error.element ?? false  {
                    self?.errorAlert()
                }
            }.disposed(by: disposeBag)
    }
    
    private func subscribeToTableViewDidSelect() {
        dropDownTableView.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            self?.dropDownTableView.deselectRow(at: indexPath, animated: true)
            if self?.mainViewModel.didselectFrom.value ?? false {
                self?.mainViewModel.countryCodeSelectedFrom.accept(self?.mainViewModel.countriesCodeBehaviour.value[indexPath.row] ?? "")
                self?.fromLabel.text = self?.mainViewModel.countryCodeSelectedFrom.value
            } else if self?.mainViewModel.didSelectTo.value ?? false {
                self?.mainViewModel.countryCodeSelectedTo.accept(self?.mainViewModel.countriesCodeBehaviour.value[indexPath.row] ?? "")
                self?.toLabel.text = self?.mainViewModel.countryCodeSelectedTo.value
            }
            self?.dropDownTableView.isHidden = true
        }).disposed(by: disposeBag)
    }
    
    private func errorAlert() {
        let alert = UIAlertController(title: "Error", message: mainViewModel.errorMessageBehaviour.value, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { [weak self]_ in
            self?.mainViewModel.errorBehavior.accept(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func navigateToDetailsView() {
        let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailsViewController") as DetailsViewController
        detailsVC.selectedFromCurrency = mainViewModel.countryCodeSelectedFrom.value
        detailsVC.selectedToCurrnecy = mainViewModel.countryCodeSelectedTo.value
        for symbol in mainViewModel.countriesCodeBehaviour.value.filter({$0 != mainViewModel.countryCodeSelectedFrom.value }) {
            detailsVC.latestSymbols.append(symbol)
        }
        self.present(detailsVC, animated: true)
    }
}
