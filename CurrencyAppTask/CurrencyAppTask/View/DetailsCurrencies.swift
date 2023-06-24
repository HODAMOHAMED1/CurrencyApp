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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
