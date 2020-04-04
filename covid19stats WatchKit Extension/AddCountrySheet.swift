//
//  AddCountrySheet.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/3/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import SwiftUI

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
