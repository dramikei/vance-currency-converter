//
//  HomeScreen.swift
//  vance-currency-converter
//
//  Created by Raghav Vashisht on 19/09/23.
//

import SwiftUI

struct HomeScreen: View {

    @StateObject var viewModel = HomeScreenVM()

    @State var selectedSegment = 0
    var body: some View {
        VStack {
            Picker("What is your favorite color?", selection: $selectedSegment) {
                Text("Convert")
                    .tag(0)
                Text("History")
                    .tag(1)
            }
            .pickerStyle(.segmented)
            .padding()

            TabView(selection: $selectedSegment) {
                CurrencyConversionView()
                    .tag(0)
                    .environmentObject(viewModel)

                CurrencyConversionHistoryView()
                    .tag(1)
                    .environmentObject(viewModel)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    HomeScreen()
}
