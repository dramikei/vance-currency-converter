//
//  LatestRates.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 20/09/23.
//

import Foundation


// MARK: - Welcome
struct LatestRateResponse: Codable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: Dictionary<String, Double>
}
