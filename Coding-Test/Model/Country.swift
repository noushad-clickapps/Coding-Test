//
//  Country.swift
//  Coding-Test
//
//  Created by Noushad on 8/24/18.
//  Copyright © 2018 Noushad. All rights reserved.
//

import Foundation

struct Country: Decodable {
    let name:String
    let languages: [Languages]
    let currencies: [Currencies]
}

struct Languages: Decodable {
    let name: String
}

struct Currencies: Decodable {
    let name: String?
}
