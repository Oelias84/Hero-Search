//
//  Hero.swift
//  HeroSearch
//
//  Created by Ofir Elias on 10/05/2021.
//

import Foundation

//MARK: - Heroes Response Model
struct HeroesResponse: Codable {
	
	let response: String
	let resultsFor: String?
	let results: [Hero]?
	let error: String?
	
	enum CodingKeys: String, CodingKey {
		
		case response
		case resultsFor = "results-for"
		case results
		case error
	}
	
}

//MARK: - Single Hero Response Model
struct HeroResponse: Codable {
	
	let response: String
	let id: String
	let name: String
	let powerstats: Powerstats
	let biography: Biography
	let appearance: Appearance
	let work: Work
	let connections: Connections
	let image: Image
	
	var hero: Hero {
		return Hero(
			id: id,
			name: name,
			powerstats: powerstats,
			biography: biography,
			appearance: appearance,
			work: work,
			connections: connections,
			image: image
		)
	}
}


//MARK: - Hero Model
struct Hero: Codable {
	
	let id: String
	let name: String
	let powerstats: Powerstats
	let biography: Biography
	let appearance: Appearance
	let work: Work
	let connections: Connections
	let image: Image
}
extension Hero: Hashable {
	public static func == (lhs: Hero, rhs: Hero) -> Bool {
		return lhs.id == rhs.id
	}

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}


class Powerstats: Codable {
	
	let intelligence: String
	let strength: String
	let speed: String
	let durability: String
	let power: String
	let combat: String
}

class Biography: Codable {
	
	let fullName: String
	let alterEgos: String
	let aliases: [String]
	let placeOfBirth: String
	let firstAppearance: String
	let publisher: String
	let alignment: String
	
	enum CodingKeys: String, CodingKey {
		
		case fullName = "full-name"
		case alterEgos = "alter-egos"
		case aliases
		case placeOfBirth = "place-of-birth"
		case firstAppearance = "first-appearance"
		case publisher
		case alignment
	}
}

class Appearance: Codable {
	
	let gender: String
	let race: String?
	let height: [String]
	let weight: [String]
	let eyeColor: String
	let hairColor: String
	
	enum CodingKeys: String, CodingKey {
		
		case gender
		case race
		case height
		case weight
		case eyeColor = "eye-color"
		case hairColor = "hair-color"
	}
}

class Work: Codable {
	
	let occupation: String
	let base: String
}

class Connections: Codable {
	
	let groupAffiliation: String
	let relatives: String
	
	enum CodingKeys: String, CodingKey {
		
		case groupAffiliation = "group-affiliation"
		case relatives
	}
}

class Image: Codable {
	
	let url: String
}

