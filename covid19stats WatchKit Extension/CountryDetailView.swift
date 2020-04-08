//
//  CountryDetailView.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/3/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import SwiftUI

struct CountryDetailView: View {
    @EnvironmentObject var model: CountriesController
    var countryId: UUID
    var country: Country {
        return self.model.countries.first(where: { $0.id == self.countryId }) ?? Country(name: "")
    }
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .trailing) {
                    CountryDetailRow(statName: "Active Cases",
                                     statValue: country.cases?.active?.withCommas() ?? "--",
                                     statNameColor: .yellow)
                    CountryDetailRow(statName: "Total Cases",
                                     statValue: country.cases?.total?.withCommas() ?? "--",
                                     statNameColor: .white)
                    CountryDetailRow(statName: "New Cases",
                                     statValue: country.cases?.new ?? "--",
                                     statNameColor: .blue)
                    CountryDetailRow(statName: "Critical Condition",
                                     statValue: country.cases?.critical?.withCommas() ?? "--",
                                     statNameColor: .orange)
                    CountryDetailRow(statName: "Recovered",
                                     statValue: country.cases?.recovered?.withCommas() ?? "--",
                                     statNameColor: .green)
                    CountryDetailRow(statName: "Total Deaths",
                                     statValue: country.deaths?.total?.withCommas() ?? "--",
                                     statNameColor: .red)
                    CountryDetailRow(statName: "New Deaths",
                                     statValue: country.deaths?.new ?? "--",
                                     statNameColor: .pink)
                    CountryDetailRow(statName: "Tests Done",
                                     statValue: country.tests?.total?.withCommas() ?? "--",
                                     statNameColor: .purple)
                    Spacer()
                }
                .navigationBarTitle(country.name)
                .onAppear {
                    self.model.updateAllStats()
                }
                Spacer()
            }
            Text("Updated \(country.formattedTime ?? "never")")
        }
    }
    
}

struct CountryDetailRow: View {
    var statName: String
    var statValue: String
    var statNameColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(statName)
                .font(.subheadline)
                .foregroundColor(statNameColor)
            Text(statValue)
                .font(.title)
                .padding(.bottom, -20)
            Divider()
        }
        
    }
}
