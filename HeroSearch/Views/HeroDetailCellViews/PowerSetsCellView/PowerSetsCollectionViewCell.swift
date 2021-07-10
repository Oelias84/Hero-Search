//
//  PowerSetsCollectionViewCell.swift
//  HeroSearch
//
//  Created by Ofir Elias on 14/05/2021.
//

import UIKit

class PowerSetsCollectionViewCell: UICollectionViewCell {
	
	var powerSets: Powerstats! {
		didSet {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.setupProgressBars()
			}
		}
	}
	@IBOutlet weak var bView: UIView!
	
	@IBOutlet weak var inteligenceProgressView: ProgressBar!
	@IBOutlet weak var strengthProgressView: ProgressBar!
	@IBOutlet weak var speedProgressView: ProgressBar!
	@IBOutlet weak var durabilityProgressView: ProgressBar!
	@IBOutlet weak var powerProgressView: ProgressBar!
	@IBOutlet weak var combatProgressView: ProgressBar!
	
		
    override func awakeFromNib() {
        super.awakeFromNib()
		setupCell()
    }
	
	
	private func setupCell() {
		bView.layer.cornerRadius = 13
	}
	private func setupProgressBars() {
		if let intelligence = Float(powerSets.intelligence) {
			inteligenceProgressView.progress = CGFloat(intelligence)
		}
		if let strength = Float(powerSets.strength) {
			strengthProgressView.progress = CGFloat(strength)
		}
		if let speed = Float(powerSets.speed) {
			speedProgressView.progress = CGFloat(speed)
		}
		if let durability = Float(powerSets.durability) {
			durabilityProgressView.progress = CGFloat(durability)
		}
		if let power = Float(powerSets.power) {
			powerProgressView.progress = CGFloat(power)
		}
		if let combat = Float(powerSets.combat) {
			combatProgressView.progress = CGFloat(combat)
		}
	}
}
