//
//  CurrencyConversionHistoryView.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 20/09/23.
//

import SwiftUI

struct CurrencyConversionHistoryView: View {
    @EnvironmentObject var viewModel: HomeScreenVM

    // Could also format the amounts here as we have in the Conversion View.
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.history, id: \.self) { item in

                    VStack {
                        HStack {
                            Text(item.sourceCurrency)
                            Spacer()
                            Text("->")
                            Spacer()
                            Text(item.destinationCurrency)
                        }

                        HStack {
                            Text("\(item.amount)")
                            Spacer()
                            Text("\(item.result)")
                        }

                        HStack {
                            Spacer()
                            Text(formatDate(date: item.date) ?? "")
                        }
                    }
                    .padding(.horizontal, 16)

                }
            }
        }
    }

    func formatDate(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    CurrencyConversionHistoryView()
}
