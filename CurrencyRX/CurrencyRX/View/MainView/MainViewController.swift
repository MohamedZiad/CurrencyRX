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
    
    private let disposeBag = DisposeBag()
    let mainViewModel = MainViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        mainViewModel.fetchAvalibleCurrencies()
        bindLoadingView()
        bindTableView()
        subscribeToTableViewDidSelect()
        subscribeToSelectedToCountry()
        subscribeToSelectedFromCountry()
        subscribeTodisableSwitch()
        subscribeToSwitchButton()
    }
    
    
    func bindLoadingView() {
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
    
    func subscribeToSelectedToCountry() {
        toButton.rx.tap.subscribe { [weak self](_) in
            self?.mainViewModel.didSelectTo.accept(true)
            self?.mainViewModel.didselectFrom.accept(false)
            self?.dropDownTableView.isHidden.toggle()
        }.disposed(by: disposeBag)
        
    }
    
    func subscribeToSelectedFromCountry() {
        fromButton.rx.tap.subscribe { [weak self](_) in
            self?.dropDownTableView.isHidden.toggle()
            self?.mainViewModel.didSelectTo.accept(false)
            self?.mainViewModel.didselectFrom.accept(true)
        }.disposed(by: disposeBag)
    }
    
    func subscribeToSwitchButton() {
        switchButton.rx.tap.subscribe { [weak self](_) in
            self?.mainViewModel.countryCodeSelectedFrom.accept(self?.toLabel.text ?? "")
            self?.mainViewModel.countryCodeSelectedTo.accept(self?.fromLabel.text ?? "")
            self?.toLabel.text = self?.mainViewModel.countryCodeSelectedTo.value
            self?.fromLabel.text = self?.mainViewModel.countryCodeSelectedFrom.value
        }.disposed(by: disposeBag)
    }
    
    
    func subscribeTodisableSwitch() {
        mainViewModel.isSwitchButtonEnabled.bind(to: switchButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func subscribeToConvertTextField() {
        converTextField.rx.text.orEmpty.bind(to: mainViewModel.converFromBehavior)
            .disposed(by: disposeBag)
        }
    
    
    func bindTableView() {
        mainViewModel.countriesCodeBehaviour.bind(to: dropDownTableView.rx.items(cellIdentifier: "CellIdentifier", cellType: DropDownCell.self)) { row, model, cell in
            cell.configureCell(currency: model)
        }.disposed(by: disposeBag)
        print(mainViewModel.countriesCodeBehaviour.value.count)
    }
    
    
    func subscribeToTableViewDidSelect() {
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
    

    
    func errorAlert() {
        let alert = UIAlertController(title: "Error", message: "Check your Internet connection and Try Again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
