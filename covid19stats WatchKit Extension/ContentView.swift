//
//  ContentView.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/1/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: CountriesController
    @State var isDetailViewPresented = false
    
    var body: some View {
        List {
            ForEach(model.countries, id: \.id) { country in
                NavigationLink(destination: CountryDetailView(countryId: country.id).environmentObject(self.model)) {
                    VStack(alignment: .leading) {
                        Text(country.name)
                        Text(country.cases?.total.description ?? "--")
                            .font(.title)
                    }
                }
            }
            .onMove(perform: { self.model.countries.move(fromOffsets: $0, toOffset: $1)})
            .onDelete(perform: {
                if self.model.countries[$0.first!].name != "All" {
                    self.model.countries.remove(atOffsets: $0)
                }
            })
            
            Button(action: {
                self.isDetailViewPresented = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Country")
                }
            }
            
            Text("Tap and hold to reorder countries in list. Swipe left to delete a country.")
                .listRowPlatterColor(.clear)
            
        }
        .onAppear {
            self.model.updateAllStats()
        }
        .sheet(isPresented: self.$isDetailViewPresented) {
            AddCountrySheet(isDetailViewPresented: self.$isDetailViewPresented).environmentObject(self.model)
        }
    }
}

struct CountryDetailView: View {
    @EnvironmentObject var model: CountriesController
    var countryId: UUID
    var country: Country {
        return self.model.countries.first(where: { $0.id == self.countryId })!
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

struct AddCountrySheet: View {
    @EnvironmentObject var model: CountriesController
    @Binding var isDetailViewPresented: Bool
    
    var body: some View {
        List {
            ForEach(model.namesOfCountries, id: \.self) { countryName in
                Button(action: {
                    self.model.addNewCountry(name: countryName)
                    self.isDetailViewPresented = false
                }) {
                    Text(countryName)
                }
            }
        }
        
    }
}

struct CountryDetailPreview: PreviewProvider {
    static var previews: some View {
        let countriesController = CountriesController()
        return CountryDetailView(countryId: countriesController.countries.first!.id).environmentObject(countriesController)
    }
}

