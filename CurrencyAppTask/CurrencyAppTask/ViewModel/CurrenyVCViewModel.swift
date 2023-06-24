//
//  CurrenyVCViewModel.swift
//  CurrencyApp
//
//  Created by hoda mohamed on 24/06/2023.
//

import Foundation
class CurrenyVCViewModel: NSObject {
    var reloadTableView: (() -> Void)?
    var updateTextValues: (() -> Void)?
    var currencys = [String]() {
        didSet {
           reloadTableView?()
        }
    }
    var convertedRate = (0.0,0.0) {
        didSet {
            updateTextValues?()
        }
    }
    func getAllCurrencies(){
//        currencys = Locale.isoCurrencyCodes
        let request = Request(path: "latest", queryParameters:[URLQueryItem(name: "access_key", value: "bec5c7e9d41544d4a5e5ce6565a4ebd4")])
        Network.shared.send(request, completion: {
            (result:Result<CurrencyConvert,Error>) in
            print(result)
            switch result {
            case .success(let currencyRate):
                if let rates =  currencyRate.rates{
                    let allCurrencys = rates.keys
                    self.currencys = Array(allCurrencys.map { String($0) }).sorted()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    func getCurrencyConverted(currency1:String,currency2:String){
        let request = Request(path: "latest", queryParameters:[URLQueryItem(name: "symbols", value: "\(currency1),\(currency2)"), URLQueryItem(name: "access_key", value: "bec5c7e9d41544d4a5e5ce6565a4ebd4")])
        Network.shared.send(request, completion: {
            (result:Result<CurrencyConvert,Error>) in
            print(result)
            switch result {
            case .success(let currencyRate):
                if let rates = currencyRate.rates{
                    if let rate1 =  rates["\(currency1)"]{
                        if let rate2 =  rates["\(currency2)"]{
                            self.convertedRate = (rate1,rate2)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
