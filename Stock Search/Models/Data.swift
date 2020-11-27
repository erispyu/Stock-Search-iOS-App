//
//  Data.swift
//  Stock Search
//
//  Created by 陈冲 on 11/26/20.
//
import UIKit
import SwiftUI
import Foundation

let backendServerUrl: String = "http://csci571-hw8-web-app.us-east-1.elasticbeanstalk.com"

let testPortfolioStockArray: [BasicStockInfo] = load("testPortfolioStockArray.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}