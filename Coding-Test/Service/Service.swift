//
//  Service.swift
//  Coding-Test
//
//  Created by Noushad on 8/24/18.
//  Copyright © 2018 Noushad. All rights reserved.
//

import Foundation

class Service {
    static let shared = Service()
    
    let kAPIUrl = "https://restcountries.eu/rest/v2/all"
    func getCountriesFromAPI(completion:@escaping ([Country]?,Error?)->()) {
        guard let url = URL(string: kAPIUrl) else {
            print("invalid url")
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 5.0)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("we have encountered an error")
                 completion(nil, error)
            }
            guard let data = data else {
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                DispatchQueue.main.async {
                    completion(countries, nil)
                }
            } catch let error {
                print("We have error decoding == \(error.localizedDescription)")
            }
            
        }.resume()
    }
}
