//
//  APIRepository.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 20/09/23.
//

import Foundation

class APIRepository {
    public static let shared: APIRepository = .init()

    private init() {}

    public func getLatestRates() async -> Result<LatestRateResponse, APIError> {
        return await APIClient.shared.send(.init(method: .get, path: "latest", query: nil, isAuthenticated: true))
    }

    // Unsupported by the free API-key
    public func convertCurrency(from: String, to: String, amount: Double) async -> Result<ConvertedCurrencyResponse, APIError> {
        return await APIClient.shared.send(
            .init(
                method: .get,
                path: "convert",
                query: [
                    .init(name: "from", value: from),
                    .init(name: "to", value: to),
                    .init(name: "amount", value: String(amount))
                ],
                isAuthenticated: true
            )
        )
    }
}
