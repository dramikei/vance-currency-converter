//
//  HomeScreenVM.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 19/09/23.
//

import SwiftUI

class HomeScreenVM: ObservableObject {

    @Published var rates: [String: Double] = [:]
    @Published var apiStatus: Status = .idle

    @Published var inputAmount = ""
    @Published var sourceCurrency = ""
    @Published var destinationCurrency = ""

    @Published var rate = 0.0
    @Published var result = ""

    @Published var history: [ConversionHistoryItem] = []

    init() {
        Task {
            await self.fetchLatestRates()
        }
    }

    func fetchLatestRates() async {
        guard apiStatus != .inProgress else { return }

        apiStatus = .inProgress
        // Base is USD
        let data = await APIRepository.shared.getLatestRates()

        DispatchQueue.main.async {
            switch data {
            case .success(let response):
                self.rates = response.rates
                let sortedCurrencies = response.rates.keys.sorted()

                self.sourceCurrency = sortedCurrencies[0]
                self.destinationCurrency = sortedCurrencies[1]
                self.calculateRate()
                
                self.apiStatus = .success
            case .failure(let err):
                self.apiStatus = .failed
                // TODO: - Show Error as toast message here.
            }
        }
    }

    func convertCurrency() {
        guard let inputAmount = Double(inputAmount) else { return }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.currencyCode = destinationCurrency

        result = numberFormatter.string(from: NSNumber(value: inputAmount * rate)) ?? ""

        history.append(.init(
            sourceCurrency: sourceCurrency,
            destinationCurrency: destinationCurrency,
            amount: inputAmount,
            result: inputAmount * rate,
            rate: rate,
            date: .now)
        )
    }

    func calculateRate() {
        guard let usdToSource = rates[sourceCurrency] else { return }
        guard let usdToDestination = rates[destinationCurrency] else { return }

        // TODO: - Check decimal
        rate = usdToDestination/usdToSource
    }
}
