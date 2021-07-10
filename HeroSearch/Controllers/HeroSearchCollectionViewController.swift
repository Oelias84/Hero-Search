//
//  HeroSearchCollectionViewController.swift
//  HeroSearch
//
//  Created by Ofir Elias on 12/05/2021.
//

import UIKit
import Foundation
import iProgressHUD

class HeroSearchCollectionViewController: UIViewController, UIScrollViewDelegate {
	
	
	@IBOutlet var collectionView: UICollectionView!
	
	private var viewModel = HeroSearchViewModel()
	private let searchController = UISearchController(searchResultsController: nil)
	private var numberOfSections = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupSearchBar()
		setUpCollectionView()
		callToViewModelForUIUpdate()
	}
}

// MARK: UICollectionViewDataSource
extension HeroSearchCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.numberOfSections
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		switch section {
		case 1:
			return viewModel.getHeroesCount()
		default:
			return viewModel.getFavoriteHeroCount()
		}
	}
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.HeaderId.collectionViewHeader, for: indexPath) as! CollectionViewHeader
		
		switch indexPath.section {
		case 1:
			header.label.text = "Search Result"
		default:
			header.label.text = "Favorites"
		}
		return header
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.HeroCollectionViewCell, for: indexPath) as! HeroCollectionViewCell
		
		var heroData: Hero {
			switch indexPath.section {
			case 1:
				return viewModel.getHeroForCell(row: indexPath.row)
			default:
				return viewModel.getFavoriteHeroFor(row: indexPath.row)
			}
		}
		cell.delegate = self
		cell.hero = heroData
		return cell
	}
}

//MARK: - SearchBar Delegate
extension HeroSearchCollectionViewController: UISearchBarDelegate {
	
	// Search button Event
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		// if the user didn't enter at least 3 characters else present an alert
		if let text = searchBar.text, text.count > 2 {
			view.showProgress()
			viewModel.getHerosDataFor(text) { hasData in
				if !hasData {
					DispatchQueue.main.async {
						self.view.dismissProgress()
					}
				}
			}
		} else {
			present(Alerts.invalidSearchAlert{searchBar.becomeFirstResponder()}, animated: true)
		}
	}
}

//MARK: - Cell Delegate
extension HeroSearchCollectionViewController: HeroCollectionViewCellDelegate {
	
	func didTap(heroData: Hero, image: UIImage) {
		let selectedHero = heroData
		let vc = (storyboard?.instantiateViewController(identifier: Constants.VCId.heroDetailViewController))! as HeroDetailViewController
		
		vc.viewModel = HeroDetailViewModel(hero: selectedHero, heroImage: image)
		navigationController?.pushViewController(vc, animated: true)
	}
}

//MARK: - Class Functions
extension HeroSearchCollectionViewController {
	
	// Setup view
	private func setupSearchBar() {
		// Get events from search bar
		searchController.searchBar.delegate = self
		// Places holder
		searchController.searchBar.placeholder = "Search Heroes"
		// Reales the view when user interact with search bar
		searchController.obscuresBackgroundDuringPresentation = false
		// Add search bar to navigation bar
		navigationItem.searchController = searchController
	}
	private func setUpCollectionView() {
		progressSpinner.attachProgress(toView: view)
		collectionView.isUserInteractionEnabled = true
		self.collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.HeaderId.collectionViewHeader)
		collectionView.collectionViewLayout = viewModel.layout()
	}
	// Binding the viewController with the viewModel
	private func callToViewModelForUIUpdate() {
		view.showProgress()
		self.viewModel.bindHeroesViewModelToController = {
			[weak self] section in
			guard let self = self else { return }
			self.updateDataSource(section: section)
		}
	}
	// Reload sections when receiving data from viewModel
	private func updateDataSource(section: Section) {
		
		DispatchQueue.main.async {
			self.view.dismissProgress()
			switch section {
			case .favorite:
				self.collectionView.reloadSections(IndexSet(integer: 0))
			case .searchResult:
				if self.numberOfSections == 2 {
					self.collectionView.reloadSections(IndexSet(integer: 1))
				} else {
					self.numberOfSections = 2
					self.collectionView.insertSections(IndexSet(integer: 1))
					self.collectionView.reloadSections(IndexSet(integer: 1))
				}
			}
		}
	}
}
