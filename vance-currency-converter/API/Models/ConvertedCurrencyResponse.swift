//
//  ConvertedCurrencyResponse.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 20/09/23.
//

import Foundation

// MARK: - Welcome
struct ConvertedCurrencyResponse: Codable {
    let success: Bool
    let query: ConversionQuery
    let info: CurrencyInfo
    let historical, date: String
    let result: Double
}

// MARK: - Info
struct CurrencyInfo: Codable {
    let timestamp: Int
    let rate: Double
}

// MARK: - Query
struct ConversionQuery: Codable {
    let from, to: String
    let amount: Int
}
