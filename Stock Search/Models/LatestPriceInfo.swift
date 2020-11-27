//
//  LatestPriceInfo.swift
//  Stock Search
//
//  Created by 陈冲 on 11/26/20.
//

import Foundation

struct LatestPriceInfo: Hashable, Codable{
    var ticker: String
    var lastPrice: Double
    var change: Double
}

let testLatestPrices = [
    LatestPriceInfo(ticker: "AAPL", lastPrice: 204.4545, change: 45.4545),
    LatestPriceInfo(ticker: "TSLA", lastPrice: 45.155, change: -515.545),
    LatestPriceInfo(ticker: "AMZN", lastPrice: 523.45456, change: 0.00000)
]