//
//  CoinModel.swift
//  bytecoin
//
//  Created by Kittisak Panluea on 25/6/2565 BE.
//

import Foundation

struct CoinModel {
    
    let rate:Double
    let currency:String
    
    var rateToString:String {
        return String(format: "%.2f", rate)
    }
    
}
