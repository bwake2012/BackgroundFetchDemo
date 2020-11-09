//
//  PokemonFetchEntry.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 11/5/20.
//

import Foundation

struct PokemonFetchEntry {

    let dateTime: Date
    let isBackground: Bool
    let name: String
    let pokemonID: Int
}

extension PokemonFetchEntry: Codable {}
