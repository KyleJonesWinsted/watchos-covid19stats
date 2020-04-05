//
//  Country.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/2/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import Foundation

class Country {
    
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
    
    init(name: String) {
        self.name = name
    }
    
    private func setStats(cases: Cases, deaths: Deaths) {
        self.cases = cases
        self.deaths = deaths
        self.updateTime = Date()
    }
    
    private func sendCountryUpdatedNotification() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("Country Updated"), object: nil)
    }
    
    public func updateStats() {
        self.getStatsJson { (result) in
            switch result {
                case .success(let json):
                    let responseArray = json["response"] as? Array<Any>
                    let response = responseArray![0] as! [String: Any]
                    let casesJson = response["cases"] as! [String: Any]
                    let deathsJson = response["deaths"] as! [String: Any]
                    let cases = Cases(new: casesJson["new"] as! String,
                                      active: casesJson["active"] as! Int,
                                      critical: casesJson["critical"] as! Int,
                                      recovered: casesJson["recovered"] as! Int,
                                      total: casesJson["total"] as! Int)
                    let deaths = Deaths(new: deathsJson["new"] as! String,
                                        total: deathsJson["total"] as! Int)
                    self.setStats(cases: cases, deaths: deaths)
                    self.sendCountryUpdatedNotification()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func getStatsJson(completionHandler: @escaping (Result<[String: Any], Error>) -> Void) {
        var components = URLComponents(string: "https://covid-193.p.rapidapi.com/statistics")!
        components.queryItems = [
            URLQueryItem(name: "country", value: self.name)
        ]
        let url = components.url!
        var request = URLRequest(url: url)
        let headers: [String: String] = [
            "x-rapidapi-host": "covid-193.p.rapidapi.com",
            "x-rapidapi-key": ConfigString.rapidApiKey.rawValue
        ]
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
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    completionHandler(.success(json))
                }
            }
        }
        task.resume()
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

enum NetworkError: Error {
    case badResponseCode(URLResponse?)
}

