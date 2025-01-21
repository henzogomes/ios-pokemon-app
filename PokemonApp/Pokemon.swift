//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Henzo Marinho Ferreira Gomes on 21/01/25.
//

import Foundation

struct Pokemon: Codable {
  let name: String
  let id: Int
  let types: [PokemonType]
  let sprites: Sprites
  let abilities: [Ability]
  let height: Int
  let weight: Int
  let cries: Cries
  
  struct PokemonType: Codable {
    let type: TypeInfo
  }
  
  struct TypeInfo: Codable {
    let name: String
  }
  
  struct Sprites: Codable {
    let front_default: String
  }
  
  struct Ability: Codable {
    let ability: AbilityInfo
  }
  
  struct AbilityInfo: Codable {
    let name: String
  }
  
  struct Cries: Codable {
    let legacy: String
  }
}
