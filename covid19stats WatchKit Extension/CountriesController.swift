//
//  CountriesController.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/2/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import Foundation
import Combine
import WatchKit

final class CountriesController: ObservableObject {
    
    static let shared = CountriesController()
    
    let objectWillChange = ObservableObjectPublisher()
    
    var countries: [Country] {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var namesOfCountries: [String]
    
    init() {
        self.countries = []
        self.namesOfCountries = []
        self.getCountryNames()
        self.loadCountries()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(countryUpdated), name: Notification.Name("Country Updated"), object: nil)
    }
    
    @objc private func countryUpdated() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    private func loadCountries() {
        let defaults = UserDefaults.standard
        let countriesStrings = defaults.stringArray(forKey: "Countries") ?? ["World"]
        for string in countriesStrings {
            self.addNewCountry(name: string)
        }
    }
    
    public func saveCountries() {
        let defaults = UserDefaults.standard
        let countriesStrings = self.countries.map { $0.name }
        defaults.set(countriesStrings, forKey: "Countries")
    }
    
    private func getCountryNames() {
        self.getCountriesJSON { (result) in
            switch result {
            case .success(let json):
                let response = json["response"] as! Array<String>
                self.namesOfCountries = response
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getCountriesJSON(completionHandler: @escaping (Result<[String: Any], Error>) -> Void) {
        //self.namesOfCountries += ["China", "South Korea", "USA", "Italy"]
        let url = URL(string: "https://covid-193.p.rapidapi.com/countries")!
        let headers = [
            "x-rapidapi-host": "covid-193.p.rapidapi.com",
            "x-rapidapi-key": ConfigString.rapidApiKey.rawValue
        ]
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    completionHandler(.failure(NetworkError.badResponseCode(response)))
                    return
            }
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completionHandler(.success(json))
                }
            }
               
        }
        task.resume()
        
    }
    
    public func updateAllStats() {
        print("update all")
        for country in self.countries {
            country.updateStats()
        }
    }
    
    public func backgroundUpdateAllStats() {
        for country in self.countries {
            country.backgroundUpdateStats()
        }
        self.scheduleBackgroundRefresh()
    }
    
    public func handleAllBackgroundDownloads(_ backgroundTask: WKURLSessionRefreshBackgroundTask) {
        if let country = countries.first(where: { $0.id.uuidString == backgroundTask.sessionIdentifier }) {
            country.handleDownload(backgroundTask)
        }
    }
    
    public func scheduleBackgroundRefresh() {
        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date().addingTimeInterval(1800), userInfo: nil) { (error) in
            if let error = error {
                print("Background task failed to schedule: \(error)")
            } else {
                print("Scheduled refresh in 1 hour")
            }
        }
    }
    
    public func addNewCountry(name: String) {
        let newCountry = Country(name: name)
        self.countries.append(newCountry)
        newCountry.updateStats()
    }
    
}
