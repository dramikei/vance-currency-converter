//
//  CurrencyPickerView.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 21/09/23.
//

import SwiftUI

struct CurrencyPickerView: View {
    var title: String
    var currencyList: [String]
    @Binding var selection: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Picker("Select currency", selection: $selection) {
                ForEach(currencyList, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

#Preview {
    CurrencyPickerView(title: "Source", currencyList: ["USD", "INR"], selection: .constant("0"))
}
