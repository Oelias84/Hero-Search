//
//  BiographyCollectionViewCell.swift
//  HeroSearch
//
//  Created by Ofir Elias on 15/05/2021.
//

import UIKit

class BiographyCollectionViewCell: UICollectionViewCell {
	
	var biography: Biography! {
		didSet {
			setupProgressBars()
		}
	}

	@IBOutlet weak var bView: UIView!
	
	@IBOutlet weak var fullName: UILabel!
	@IBOutlet weak var placeOfBirth: UILabel!
	@IBOutlet weak var aliases: UILabel!
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		setupCell()
	}
	
	private func setupCell() {
		bView.layer.cornerRadius = 13
	}
	private func setupProgressBars() {
		fullName.text = biography.fullName
		placeOfBirth.text = biography.placeOfBirth
		aliases.text = biography.aliases.joined(separator: " ,")
	}
}
