//
//  HeroDetailViewController.swift
//  HeroSearch
//
//  Created by Ofir Elias on 13/05/2021.
//

import UIKit
import Foundation

class HeroDetailViewController: UIViewController {
	
	var viewModel: HeroDetailViewModel!
	
	@IBOutlet weak var heroImageView: UIImageView!
	@IBOutlet weak var biographyBackgroundView: UIView!
	@IBOutlet weak var alignmentLabel: UILabel!
	@IBOutlet weak var publiserLabel: UILabel!
	@IBOutlet weak var pageControl: UIPageControl!
	 
	private lazy var shareButton: UIBarButtonItem = {
		let button = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain , target: self, action: #selector(shareButtonPressed(_:)))
		button.tintColor = .systemBlue
		return button
	}()
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpCollectionView()
		setupView()
	}
}

extension HeroDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		3
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		switch indexPath.row {
		case 1:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.appearanceCollectionViewCell,
														  for: indexPath) as! AppearanceCollectionViewCell
			if let appearance = viewModel.getHeroDetails(for: .appearance) as? Appearance {
				cell.appearance = appearance
			}
			return cell
		case 2:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.biographyCollectionViewCell,
														  for: indexPath) as! BiographyCollectionViewCell
			if let biography = viewModel.getHeroDetails(for: .biography) as? Biography {
				cell.biography = biography
			}
			return cell
		default:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellId.powerSetsCollectionViewCell,
														  for: indexPath) as! PowerSetsCollectionViewCell
			if let powerStats = viewModel.getHeroDetails(for: .powerStats) as? Powerstats {
				cell.powerSets = powerStats
			}
			return cell
		}
	}
}

extension HeroDetailViewController {
	
	private func setupView() {
		let cornerRadius: CGFloat = 12
		title = viewModel.getHeroName()
		
		alignmentLabel.text = viewModel.getBiography().alignment.capitalized
		publiserLabel.text = viewModel.getBiography().publisher
		heroImageView.image = viewModel.getHeroImageView()
		
		heroImageView.layer.cornerRadius = cornerRadius
		biographyBackgroundView.layer.cornerRadius = cornerRadius
		self.navigationItem.rightBarButtonItem = self.shareButton
	}
	private func setUpCollectionView() {
		viewModel.layout(collectionView){
			[weak self] row in
			guard let self = self else { return }
			self.pageControl.currentPage = row
		}
		
		// Register Cells
		collectionView.register(UINib(nibName: Constants.CellId.powerSetsCollectionViewCell, bundle: .main),
								forCellWithReuseIdentifier: Constants.CellId.powerSetsCollectionViewCell)
		collectionView.register(UINib(nibName: Constants.CellId.appearanceCollectionViewCell, bundle: .main),
								forCellWithReuseIdentifier: Constants.CellId.appearanceCollectionViewCell)
		collectionView.register(UINib(nibName: Constants.CellId.biographyCollectionViewCell, bundle: .main),
								forCellWithReuseIdentifier: Constants.CellId.biographyCollectionViewCell)
	}
	@objc private func shareButtonPressed(_ sender: Any) {
		let name = viewModel.getHeroName()
		let image = viewModel.getHeroImageView()
		let biography = viewModel.getHeroDetails(for: .biography) as! Biography
		
		let activity = UIActivityViewController(activityItems: [biography.publisher, name, image], applicationActivities: nil)
		present(activity, animated: true)
	}
}
