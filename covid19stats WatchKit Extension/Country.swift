//
//  Country.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/2/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import Foundation
import WatchKit

class Country: NSObject, URLSessionDownloadDelegate {
    
    var id = UUID()
    var name: String
    var cases: Cases?
    var deaths: Deaths?
    var tests: Tests?
    var updateTime: Date?
    var formattedTime: String? {
        guard let updateTime = self.updateTime else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: updateTime)
    }
    
    var pendingBackgroundTasks = [WKURLSessionRefreshBackgroundTask]()
    
    init(name: String) {
        self.name = name
    }
    
    private func setStats(cases: Cases, deaths: Deaths, tests: Tests) {
        self.cases = cases
        self.deaths = deaths
        self.tests = tests
        self.updateTime = Date()
        self.sendCountryUpdatedNotification()
    }
    
    private func sendCountryUpdatedNotification() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("Country Updated"), object: nil)
    }
    
    public func updateStats() {
        let now = Date()
        if let updateTime = self.updateTime,
            now < updateTime.addingTimeInterval(900) {
            return
        }
        print("update \(self.name)")
        self.getStatsJson { (result) in
            switch result {
                case .success(let json):
                    self.processJSONAndSetStats(with: json)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    private func processJSONAndSetStats(with json: [String: Any]) {
        let responseArray = json["response"] as? Array<Any>
        guard let response = responseArray?[0] as? [String: Any] else { return }
        let casesJson = response["cases"] as? [String: Any]
        let deathsJson = response["deaths"] as? [String: Any]
        let testsJSon = response["tests"] as? [String: Any]
        let cases = Cases(new: casesJson?["new"] as? String,
                          active: casesJson?["active"] as? Int,
                          critical: casesJson?["critical"] as? Int,
                          recovered: casesJson?["recovered"] as? Int,
                          total: casesJson?["total"] as? Int)
        let deaths = Deaths(new: deathsJson?["new"] as? String,
                            total: deathsJson?["total"] as? Int)
        let tests = Tests(total: testsJSon?["total"] as? Int)
        self.setStats(cases: cases, deaths: deaths, tests: tests)
    }
    
    private func getStatsJson(completionHandler: @escaping (Result<[String: Any], Error>) -> Void) {
        let request = self.createURLRequest()
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
    
    private func createURLRequest() -> URLRequest {
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
        return request
    }
    
    public func backgroundUpdateStats() {
        let configuration = URLSessionConfiguration.background(withIdentifier: self.id.uuidString)
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let request = self.createURLRequest()
        let backgroundTask = session.downloadTask(with: request)
        backgroundTask.resume()
    }
    
    public func handleDownload(_ backgroundTask: WKURLSessionRefreshBackgroundTask) {
        let configuration = URLSessionConfiguration.background(withIdentifier: backgroundTask.sessionIdentifier)
        let _ = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        pendingBackgroundTasks.append(backgroundTask)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                self.processJSONAndSetStats(with: json)
        }
        
        self.pendingBackgroundTasks.forEach {
            $0.setTaskCompletedWithSnapshot(false)
        }
        
        
        CountriesController.shared.scheduleBackgroundRefresh()
    }
    
    
}

struct Cases: Codable {
    var new: String?
    var active, critical, recovered, total: Int?
}

struct Deaths: Codable {
    var new: String?
    var total: Int?
}

struct Tests: Codable {
    var total: Int?
}

enum NetworkError: Error {
    case badResponseCode(URLResponse?)
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
