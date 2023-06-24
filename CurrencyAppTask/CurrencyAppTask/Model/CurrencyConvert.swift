//
//  Team.swift
//  HiNewzV1
//
//  Created by hoda mohamed on 24/06/2023.
//

import Foundation

class CurrencyConvert:Model,Decodable{
    var success : Bool?
    var timestamp:Int?
    var base:String?
    var date:String?
    var rates: [String: Double]?
    enum CodingKeys: String, CodingKey {
        case success,timestamp,base,date,rates
    }
}
