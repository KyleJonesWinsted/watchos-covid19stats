//
//  ContentView.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/1/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var testModel = TestModel()
    @State var isDetailViewPresented = false
    
    var body: some View {
        List {
            ForEach(testModel.testCellNames, id: \.self) { cellName in
                NavigationLink(destination: TestDetailView(text: cellName)) {
                    Text(cellName)
                }
            }
            .onMove(perform: { self.testModel.testCellNames.move(fromOffsets: $0, toOffset: $1)})
            .onDelete(perform: { self.testModel.testCellNames.remove(atOffsets: $0)})
            
            Button(action: {
                self.isDetailViewPresented = true
            }) {
                Text("Show sheet")
            }
            .sheet(isPresented: self.$isDetailViewPresented) {
                TestSheet(text: "Hello", isDetailViewPresented: self.$isDetailViewPresented)
            }
        }
    }
}

struct TestDetailView: View {
    var text: String
    
    var body: some View {
        Text(text)
        .navigationBarTitle(text)
    }
}

struct TestSheet: View {
    var text: String
    @Binding var isDetailViewPresented: Bool
    
    var body: some View {
        Button(action: {
            self.isDetailViewPresented = false
        }) {
            Text(text)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            TestDetailView(text: "Hello")
            TestSheet(text: "Hi Again", isDetailViewPresented: .constant(false))
        }
    }
}
