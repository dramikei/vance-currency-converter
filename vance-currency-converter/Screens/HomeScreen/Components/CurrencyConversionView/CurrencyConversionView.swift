//
//  CurrencyConversionView.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 20/09/23.
//

import SwiftUI

struct CurrencyConversionView: View {
    @EnvironmentObject var viewModel: HomeScreenVM

    var sourceCurrencies: [String] {
        viewModel.rates.keys.sorted().filter({ $0.lowercased() != viewModel.destinationCurrency.lowercased() })
    }

    var destinationCurrencies: [String] {
        viewModel.rates.keys.sorted().filter({ $0.lowercased() != viewModel.sourceCurrency.lowercased() })
    }

    var conversionView: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center, spacing: 16) {

                CurrencyPickerView(
                    title: "Source",
                    currencyList: sourceCurrencies,
                    selection: $viewModel.sourceCurrency
                )

                Button {
                    swap(&viewModel.sourceCurrency, &viewModel.destinationCurrency)
                } label: {
                    Image(systemName: "arrow.right.arrow.left")
                }


                CurrencyPickerView(
                    title: "Destination",
                    currencyList: destinationCurrencies,
                    selection: $viewModel.destinationCurrency
                )
            }
            .frame(maxWidth: .infinity)

            VStack {
                Text("Rate: \(viewModel.rate)")
            }

            TextField("Enter Amount", text: $viewModel.inputAmount)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding(.horizontal, 16)
                .onSubmit {
                    viewModel.convertCurrency()
                }

            Button {
                viewModel.convertCurrency()
            } label: {
                Text("Submit")
            }

            Text(viewModel.result)

        }
        .padding(.horizontal)
        .onChange(of: viewModel.sourceCurrency) {
            viewModel.calculateRate()
        }
        .onChange(of: viewModel.destinationCurrency) {
            viewModel.calculateRate()
        }
    }

    var body: some View {
        switch viewModel.apiStatus {
        case .idle, .inProgress:
            ProgressView()
        case .success:
            conversionView
        case .failed:
            Text("Error Loading API")
        }

    }
}

#Preview {
    CurrencyConversionView()
}
