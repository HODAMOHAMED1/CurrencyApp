//
//  DetailsCurrenciesViewModel.swift
//  CurrencyApp
//
//  Created by hoda mohamed on 24/06/2023.
//

import Foundation
class DetailsCurrenciesViewModel: NSObject {
    var todayData = (0.0,0.0)
    var yesterDayData = (0.0,0.0)
    var beforeYesterDayData = (0.0,0.0)
    var detailsViewModels = [DetailsCellViewModel](){
        didSet {
           reloadTableView?()
        }
    }
    var reloadTableView: (() -> Void)?
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
            let request = Request(path: dateString, queryParameters:[URLQueryItem(name: "symbols", value: "\(currency1),\(currency2)"), URLQueryItem(name: "access_key", value: "bec5c7e9d41544d4a5e5ce6565a4ebd4")])
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
}
