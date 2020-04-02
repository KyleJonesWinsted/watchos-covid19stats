//
//  TestModel.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/1/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import Foundation

class TestModel: ObservableObject {

    @Published var testCellNames = [String]()
    
    init() {
        testCellNames += ["One", "Two", "Three"]
    }
}
