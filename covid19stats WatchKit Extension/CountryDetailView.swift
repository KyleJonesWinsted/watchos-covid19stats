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
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Total Cases")
                        Text(country.cases?.total.description ?? "--")
                            .font(.largeTitle)
                        Text("New Cases")
                            .foregroundColor(.blue)
                        Text(country.cases?.new ?? "--")
                            .font(.title)
                        Text("Active")
                            .foregroundColor(.yellow)
                        Text(country.cases?.active.description ?? "--")
                            .font(.title)
                        Text("Critical Condition")
                            .foregroundColor(.orange)
                        Text(country.cases?.critical.description ?? "--")
                            .font(.title)
                        Text("Recovered")
                            .foregroundColor(.green)
                        Text(country.cases?.recovered.description ?? "--")
                            .font(.title)
                    }
                    VStack(alignment: .leading) {
                        Text("Total Deaths")
                            .foregroundColor(.red)
                        Text(country.deaths?.total.description ?? "--")
                            .font(.title)
                        Text("New Deaths")
                            .foregroundColor(.pink)
                        Text(country.deaths?.new ?? "--")
                            .font(.title)
                    }
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
    
    func getCountry() {
        return
    }
}
