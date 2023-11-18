//
//  Model.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 09.11.2023.
//

import Foundation


struct CharactersModel : Codable {
    var info: Info
    var results: [Results]
}

struct Info: Codable {
    let count, pages: Int?
    let next, prev: String?
}

struct Results: Codable {
    var id: Int
    var name: String
    var episode: String
    var characters: [String]
}

struct Episode: Codable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var origin: Origin
    var location: Location
    var image: String
}

struct Origin: Codable{
    var name: String
    var url: String
}

struct Location: Codable{
    var name: String
    var url: String
}

