//
//  CountryViewModel.swift
//  Coding-Test
//
//  Created by Noushad on 8/24/18.
//  Copyright © 2018 Noushad. All rights reserved.
//

import Foundation

class CountryViewModel {
    
    let name: String
    var currency: String
    var language: String
    var isBombIconVisible = false
    
    init(country:Country) {
        self.name = country.name
        self.language = ""
        self.currency = ""
        if country.languages.count != 0 {
         self.language = country.languages[0].name
        }
        if country.currencies.count != 0 {
            if let currency = country.currencies[0].name {
                self.currency = currency
            }
        }
    }
}
