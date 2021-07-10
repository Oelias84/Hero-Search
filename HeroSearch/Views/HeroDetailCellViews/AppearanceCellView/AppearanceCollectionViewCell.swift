//
//  AppearanceCollectionViewCell.swift
//  HeroSearch
//
//  Created by Ofir Elias on 15/05/2021.
//

import UIKit

class AppearanceCollectionViewCell: UICollectionViewCell {
	
	var appearance: Appearance! {
		didSet {
			setupProgressBars()
		}
	}

	@IBOutlet weak var bView: UIView!
	
	@IBOutlet weak var ganderLabel: UILabel!
	@IBOutlet weak var raceLabel: UILabel!
	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var eyeColorLabel: UILabel!
	@IBOutlet weak var hairColorLabel: UILabel!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		setupCell()
	}
	
	private func setupCell() {
		bView.layer.cornerRadius = 13
	}
	private func setupProgressBars() {
		ganderLabel.text = appearance.gender
		raceLabel.text = appearance.race?.checkNull
		heightLabel.text = appearance.height[1]
		eyeColorLabel.text = appearance.eyeColor
		hairColorLabel.text = appearance.hairColor
	}
}
