//
//  Extensions.swift
//  CurrencyApp
//
//  Created by hoda mohamed on 24/06/2023.
//

import Foundation
extension Date {
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
