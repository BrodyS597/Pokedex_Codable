//
//  Pokemon.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation

struct Pokedex: Decodable {
    let results: [PokedexResult]
}

struct PokedexResult: Decodable {
    let name: String
    let url: String
}
