//
//  DetailsCurrenciesViewModel.swift
//  CurrencyApp
//
//  Created by hoda mohamed on 24/06/2023.
//

import Foundation
class DetailsCurrenciesViewModel: NSObject {
    var ratesData = [String: Double]()
    var otherCurrenciesModels = [DetailsCellViewModel](){
        didSet {
           reloadOtherCurrenciesTableView?()
        }
    }
    var detailsViewModels = [DetailsCellViewModel](){
        didSet {
           reloadTableView?()
        }
    }
    var reloadTableView: (() -> Void)?
    var reloadOtherCurrenciesTableView: (() -> Void)?
    func getAllHistoricalCurrencies(currency1:String,currency2:String,currency1Value:String){
        let dispatchGroup = DispatchGroup()
        var vms = [DetailsCellViewModel]()
        for i in 0...2{
            var currentDate = Date()
            if i == 1{
                currentDate = Date().dayBefore
            }
            if i == 2{
                let yesterday = Date().dayBefore
                currentDate = yesterday.dayBefore
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: currentDate)
            let request = Request(path: dateString, queryParameters:[URLQueryItem(name: "symbols", value: "\(currency1),\(currency2)"), URLQueryItem(name: "access_key", value: "db058a5d9add43e56513e1f069fddf86")])
            dispatchGroup.enter()
            Network.shared.send(request, completion: {
                (result:Result<CurrencyConvert,Error>) in
                print(result)
                switch result {
                case .success(let currencyRate):
                    var vm = DetailsCellViewModel(currencyValue: "",dayNumber: i)
                    if let rates = currencyRate.rates{
                        if let rate1 =  rates["\(currency1)"]{
                            if let rate2 =  rates["\(currency2)"]{
                                let finalRate:Double = rate2/rate1
                                if let currency1Double = Double(currency1Value){
                                let currency2Aprox = String(format: "%.5f", finalRate*currency1Double)
                                    vm.currencyValue = "\(currency1Value) \(currency1) = \(currency2Aprox) \(currency2)"
                                }
                            }
                        }
                    }
                    vms.append(vm)
                    dispatchGroup.leave()
                case .failure(let error):
                    print(error)
                }
            })
        }
        dispatchGroup.notify(queue: .main) {
            // at this point all tasks are completed, do whatever you wish
            self.detailsViewModels = vms.sorted(by: {$0.dayNumber<$1.dayNumber})
        }
    }
    func getOtherCurrenciesRate(baseCurrency:String,baseValue:String){
        let popular_10 = ["USD","EUR","JPY","GBP","AUD","CAD","CHF","CNH","HKD","NZD"]
        var vms = [DetailsCellViewModel]()
        for item in popular_10{
            if ratesData.keys.contains(item){
                if let rate1 =  ratesData["\(baseCurrency)"]{
                    if let rate2 =  ratesData[item]{
                        let finalRate:Double = rate2/rate1
                        if let currency1Double = Double(baseValue){
                        let currency2Aprox = String(format: "%.5f", finalRate*currency1Double)
                            var vm = DetailsCellViewModel(currencyValue: "",dayNumber: 0)
                            vm.currencyValue = "\(baseValue)\(baseCurrency) = \(currency2Aprox)\(item)"
                            vms.append(vm)
                        }
                    }
                }
            }
        }
        otherCurrenciesModels = vms
    }
}

