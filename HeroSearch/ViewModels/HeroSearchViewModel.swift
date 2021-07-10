//
//  HeroSearchViewModel.swift
//  HeroSearch
//
//  Created by Ofir Elias on 10/05/2021.
//

import UIKit
import iProgressHUD

enum Section {
	
	case favorite
	case searchResult
}

class HeroSearchViewModel: NSObject {
	
	private var apiService: HeroAPIService!
	private let progressBar = iProgressHUD.sharedInstance()
	
	private(set) var favoriteHeroesData: [HeroResponse]? {
		didSet {
			self.bindHeroesViewModelToController(.favorite)
		}
	}
	private(set) var heroesData: HeroesResponse? {
		didSet {
			self.bindHeroesViewModelToController(.searchResult)
		}
	}
	
	var bindHeroesViewModelToController : ((Section) -> ()) = {_ in}
	
	override init() {
		super.init()
		self.apiService = HeroAPIService()
		self.getFavoriteHeroes()
	}
	
	func getFavoriteHeroCount() -> Int {
		return favoriteHeroesData?.count ?? 0
	}
	func getFavoriteHeroFor(row: Int) -> Hero {
		return favoriteHeroesData![row].hero
	}
	func getHeroesCount() -> Int {
		return heroesData?.results?.count ?? 0
	}
	func getHeroForCell(row: Int) -> Hero {
		return heroesData!.results![row]
	}
	func getHeroDetails(for index: IndexPath) -> Hero {
		var heroDetail: Hero!
		switch index.section {
		case 1:
			if let hero = heroesData?.results?[index.row] {
				heroDetail = hero
			}
		default:
			if let hero = favoriteHeroesData?[index.row].hero {
				heroDetail = hero
			}
		}
		return heroDetail
	}
	
	func getHerosDataFor(_ name: String, completion: @escaping (Bool) -> ()) {
		self.apiService.fetchHeroData(by: name) { result in
			switch result {
			case .success(let response):
				self.heroesData = response
			case .failure(let error):
				completion(false)
				self.networkErrorHandle(for: error)
			}
		}
	}
	private func getFavoriteHeroes() {
		self.apiService.fetchFavoriteHeroesData(by: [213,717,502,303,423]) { result in
			
			switch result {
			case .success(let heroes):
				self.favoriteHeroesData = heroes
			case .failure(let error):
				self.networkErrorHandle(for: error)
			}
		}
	}
	
	//MARK: - CollectionView CompositionalLayout
	func layout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
			// Header size
			let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
			let sectionLayoutBoundarySize = NSCollectionLayoutBoundarySupplementaryItem(
				layoutSize: sectionHeaderSize,
				elementKind: Constants.HeaderId.collectionViewHeader,
				alignment: .topLeading)
			
			sectionLayoutBoundarySize.contentInsets.leading = 16
			if sectionIndex == 0 {
				// Favorite section
				let itemSize = NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(0.5),
					heightDimension: .fractionalHeight(1.0))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				item.contentInsets.leading = 16
				
				let groupSize = NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(0.92),
					heightDimension: .absolute(250))
				let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
				
				let section = NSCollectionLayoutSection(group: group)
				section.orthogonalScrollingBehavior = .continuous
				section.boundarySupplementaryItems = [sectionLayoutBoundarySize]
				
				return section
			} else {
				// Search Result section
				let itemSize = NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(0.5),
					heightDimension: .absolute(275))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
				
				let groupSize = NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1),
					heightDimension: .estimated(1000))
				let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
				
				let section = NSCollectionLayoutSection(group: group)
				section.boundarySupplementaryItems = [sectionLayoutBoundarySize]
				
				return section
			}
		}
		
		return layout
	}
	
	//MARK: - Present alert for giving error
	private func networkErrorHandle(for error: NetworkError) {
		
		switch error {
		case .badURL(let error):
			DispatchQueue.main.async {
				Alerts.networkErrorAlert(title: "Bad Input", message: error)
			}
		case .error(let error):
			DispatchQueue.main.async {
				Alerts.networkErrorAlert(title: "Error", message: error)
			}
		case .responseError(let error):
			print(error)
		case .dataError(let title, let error):
			DispatchQueue.main.async {
				Alerts.networkErrorAlert(title: title, message: error)
			}
		}
	}
}

extension Data {
	var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
		guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
			  let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
			  let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
		
		return prettyPrintedString
	}
}
