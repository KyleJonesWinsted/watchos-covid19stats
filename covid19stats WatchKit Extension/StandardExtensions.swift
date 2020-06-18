//
//  StandardExtensions.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 6/15/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import Foundation


extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


extension Int {
    func shortFormat() -> String {
        let numberOfDigits = String(self).count
        let doubleSelf = Double(self)
        switch numberOfDigits {
        case 0...3:
            return String(self)
        case 4:
            return String(format: "%.2f", doubleSelf / 1000.0) + "K"
        case 5:
            return String(format: "%.1f", doubleSelf / 1000.0) + "K"
        case 6:
            return String(Int(doubleSelf / 1000)) + "K"
        case 7:
            return String(format: "%.2f", doubleSelf / 1000000.0) + "M"
        case 8:
            return String(format: "%.1f", doubleSelf / 1000000.0) + "M"
        case 9:
            return String(Int(doubleSelf / 1000000)) + "M"
        case 10...Int.max:
            return String(format: "%.2f", doubleSelf / 1000000000) + "B"
        default:
            return String(doubleSelf)
        }
    }
}
