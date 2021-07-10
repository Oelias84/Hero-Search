//
//  HeroCollectionViewCell.swift
//  HeroSearch
//
//  Created by Ofir Elias on 12/05/2021.
//

import UIKit
import Combine
import Foundation
import iProgressHUD

protocol HeroCollectionViewCellDelegate: AnyObject {
	
	func didTap(heroData: Hero, image: UIImage)
}

class HeroCollectionViewCell: UICollectionViewCell {
		
	private var cancellable: AnyCancellable?
	private var animator: UIViewPropertyAnimator?

	var hero: Hero! {
		didSet {
			configure()
		}
	}
	
	@IBOutlet weak var heroImageView: UIImageView!
	@IBOutlet weak var heroNameLabel: UILabel!
	@IBOutlet weak var heroPublisher: UILabel!
	
	weak var delegate: HeroCollectionViewCellDelegate?
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		setupUI()
	}
	
	// Reset Cell data
	override func prepareForReuse() {
	  super.prepareForReuse()
		
		heroImageView.alpha = 0.0
		heroImageView.image = nil
		animator?.stopAnimation(true)
		cancellable?.cancel()
	}
	// Setup UI
	private func setupUI() {
		contentView.layer.cornerRadius = 13
		contentView.layer.borderWidth = 1.0
		contentView.layer.masksToBounds = true
		heroImageView.clipsToBounds = true
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped)))
	}
	// Configure cell with hero data
	private func configure() {
		heroNameLabel.text = hero.name
		heroPublisher.text = hero.biography.publisher.components(separatedBy: " ").first
		cancellable = loadImage(for: hero).sink {
			[weak self] image in
			guard let self = self else { return }
			self.showImage(image: image)
		}
	}
	// Loading Hero Image
	private func loadImage(for movie: Hero) -> AnyPublisher<UIImage?, Never> {
		return Just(movie.image.url).flatMap({ poster -> AnyPublisher<UIImage?, Never> in
			let url = URL(string: movie.image.url)!
			return ImageLoader.shared.loadImage(from: url)
		})
		.eraseToAnyPublisher()
	}
	// Show Hero image with animation
	private func showImage(image: UIImage?) {
		animator?.stopAnimation(false)
		heroImageView.image = image
		animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
			self.heroImageView.alpha = 1.0
		})
	}
	
	@objc func cellTapped() {
		delegate?.didTap(heroData: hero, image: heroImageView.image!)
	}
}
