//
//  APIManager.swift
//  HeroSearch
//
//  Created by Ofir Elias on 10/05/2021.
//

import UIKit
import Foundation

enum NetworkError: Error {
	
	case badURL(String)
	case error(String)
	case responseError(String)
	case dataError(String,String)
}

class HeroAPIService {
	
	let token = "10225384696865914"
	let baseURL = "https://superheroapi.com/api/"
	
	func fetchHeroData(by name: String, completion: @escaping (Result<HeroesResponse,NetworkError>) -> ()) {
		
		let urlString = baseURL + token + "/search/\(name)"
		//Check for URL
		guard let sourcesURL = URL(string: urlString) else {
			completion(.failure(.badURL("Could't start a search for: \"\(name)\"")))
			return
		}
		
		URLSession.shared.dataTask(with: sourcesURL) { (data, response, error) in
			// Check if there is an error
			if let error = error {
				completion(.failure(.error(error.localizedDescription)))
				return
			}
			// Check for response status
			if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
				completion(.failure(.responseError("Status code was not 200, Received error: \(httpResponse.statusCode)")))
				return
			}
			// Check if has data and decode it to HeroesResponse object
			if let data = data {
				do {
					let heroesData = try JSONDecoder().decode(HeroesResponse.self, from: data)
					if let error = heroesData.error {
						completion(.failure(.dataError("Search failed", error)))
					} else {
						completion(.success(heroesData))
					}
				} catch {
					completion(.failure(.dataError("Failed Decoding Data", error.localizedDescription)))
				}
			}
		}.resume()
	}
	func fetchFavoriteHeroesData(by ids: [Int], completion: @escaping (Result<[HeroResponse],NetworkError>) -> ()) {
		
		var heroResponse = [HeroResponse]()
		let idCounter = ids.count
		for id in ids {
			//Check for URL
			let urlString = baseURL + token + "/\(id)"
			guard let sourcesURL = URL(string: urlString) else {
				completion(.failure(.badURL("There was an issue with the giving url:" + urlString)))
				return
			}
			URLSession.shared.dataTask(with: sourcesURL) { (data, response, error) in
				// Check if there is an error
				if let error = error {
					completion(.failure(.error(error.localizedDescription)))
					return
				}
				// Check for response status
				guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
					completion(.failure(.responseError("Not 200")))
					return
				}
				// Check if has data and decode it to HeroesResponse object
				if let data = data {
					let jsonDecoder = JSONDecoder()
					do {
						let heroData = try jsonDecoder.decode(HeroResponse.self, from: data)
						
						if heroData.response == "success" {
							heroResponse.append(heroData)
						} else {
							completion(.failure(.dataError("Search failed", heroData.response)))
						}
						
						// if finished fetching all ids call completion
						if idCounter == heroResponse.count {
							completion(.success(heroResponse))
						}
					} catch {
						completion(.failure(.dataError("Failed Decoding Data", error.localizedDescription)))
					}
				}
			}.resume()
		}
	}
}
