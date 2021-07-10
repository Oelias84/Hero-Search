//
//  HeroDetailViewModel.swift
//  HeroSearch
//
//  Created by Ofir Elias on 13/05/2021.
//

import UIKit

enum DetailType {
	
	case powerStats
	case biography
	case appearance
}

class HeroDetailViewModel {
	
	private let hero: Hero!
	private let heroImage: UIImage!
	
	init(hero: Hero, heroImage: UIImage) {
		self.hero = hero
		self.heroImage = heroImage
	}
	
	func getHeroImageView() -> UIImage {
		return heroImage
	}
	func getHeroName() -> String {
		return hero.name
	}
	func getBiography() -> Biography {
		return hero.biography
	}
	func getHeroDetails(for type: DetailType) -> AnyObject {
		
		switch type {
		case .powerStats:
			return hero.powerstats
		case .biography:
			return hero.biography
		case .appearance:
			return hero.appearance
		}
	}
	
	//MARK: - CollectionView CompositionalLayout
	func layout(_ collectionView: UICollectionView, callBack: @escaping (Int)->()) {
		
		let layout = UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
			
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0))
			
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			
			let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
			
			let section = NSCollectionLayoutSection(group: group)
			section.orthogonalScrollingBehavior = .paging
			
			var rowToCompare = 0
			section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
				let currentPage = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))
				if rowToCompare != currentPage {
					callBack(currentPage)
					rowToCompare = currentPage
				}
			}
			return section
		}
		collectionView.collectionViewLayout = layout
	}
}
