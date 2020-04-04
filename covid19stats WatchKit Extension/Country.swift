//
//  Country.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/2/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import Foundation

struct Country {
    
    var id = UUID()
    var name: String
    var cases: Cases?
    var deaths: Deaths?
    var updateTime: Date?
    var formattedTime: String? {
        guard let updateTime = self.updateTime else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: updateTime)
    }
    
    public mutating func updateStats() {
        let newCases = Cases(new: "+\(Int.random(in: 1...5000))", active: Int.random(in: 400...1000000), critical: Int.random(in: 1...3000), recovered: Int.random(in: 1...5000), total: Int.random(in: 500...1000000))
        let newDeaths = Deaths(new: "+\(Int.random(in: 1...500))", total: Int.random(in: 1...3000))
        self.cases = newCases
        self.deaths = newDeaths
        self.updateTime = Date()
    }
}

struct Cases {
    var new: String
    var active, critical, recovered, total: Int
}

struct Deaths {
    var new: String
    var total: Int
}
