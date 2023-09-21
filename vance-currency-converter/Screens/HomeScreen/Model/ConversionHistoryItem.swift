//
//  ConversionHistoryItem.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 21/09/23.
//

import Foundation


struct ConversionHistoryItem: Hashable {
    let sourceCurrency: String
    let destinationCurrency: String
    let amount: Double
    let result: Double
    let rate: Double

    let date: Date
}
