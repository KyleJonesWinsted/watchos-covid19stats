//
//  CountriesController.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/2/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import Foundation

final class CountriesController: ObservableObject {
    
    @Published var countries: [Country]
    @Published var namesOfCountries: [String]
    
    init() {
        self.countries = [Country(name: "All")]
        self.namesOfCountries = []
        self.getCountryNames()
    }
    
    private func getCountryNames() {
        self.namesOfCountries += ["China", "South Korea", "USA", "Italy"]
    }
    
    public func updateAllStats() {
        var updatedCountries = [Country]()
        for var country in self.countries {
            country.updateStats()
            updatedCountries.append(country)
        }
        self.countries = updatedCountries
    }
    
    public func addNewCountry(name: String) {
        var newCountry = Country(name: name)
        newCountry.updateStats()
        self.countries.append(newCountry)
    }
    
}
