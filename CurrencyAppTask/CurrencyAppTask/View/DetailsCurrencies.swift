//
//  DetailsCurrencies.swift
//  CurrencyApp
//
//  Created by hoda mohamed on 24/06/2023.
//

import UIKit

class DetailsCurrencies: UIViewController {
    @IBOutlet weak var historicalTable: UITableView!
    
    @IBOutlet weak var otherCurrenciesTable: UITableView!
    var currency1 = ""
    var currency2 = ""
    var currency1Value = ""
    lazy var viewModel = {
        DetailsCurrenciesViewModel()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        historicalTable.register(UINib(nibName: "DetailsCell", bundle: nil), forCellReuseIdentifier: "DetailsCell")
        otherCurrenciesTable.register(UINib(nibName: "DetailsCell", bundle: nil), forCellReuseIdentifier: "DetailsCell")
        viewModel.getAllHistoricalCurrencies(currency1: currency1, currency2: currency2, currency1Value: currency1Value)
        viewModel.reloadTableView = {
            self.historicalTable.reloadData()
        }
        viewModel.getOtherCurrenciesRate(baseCurrency: currency1, baseValue: currency1Value)
        viewModel.reloadOtherCurrenciesTableView = {
            self.otherCurrenciesTable.reloadData()
        }
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
extension DetailsCurrencies:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historicalTable{
            return viewModel.detailsViewModels.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historicalTable{
            return 1
        }
        return viewModel.otherCurrenciesModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as? DetailsCell else{
            return UITableViewCell()
        }
        if tableView == historicalTable{
            if viewModel.detailsViewModels[indexPath.section].dayNumber == indexPath.section{
                cell.cellViewModel = viewModel.detailsViewModels[indexPath.section]
            }
        }else{
            cell.cellViewModel = viewModel.otherCurrenciesModels[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == historicalTable{
            if section == 0{
                return "Today"
            }else if section == 1{
                return "Yesterday"
            }
            return "Before Yesterday"
        }
        return "Other Currencies"
    }
}
