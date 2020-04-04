//
//  ContentView.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/1/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import SwiftUI

struct CountriesListView: View {
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
        .navigationBarTitle("COVID19 Stats")
        .sheet(isPresented: self.$isDetailViewPresented) {
            AddCountrySheet(isDetailViewPresented: self.$isDetailViewPresented).environmentObject(self.model)
        }
    }
}


