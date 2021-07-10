//
//  CollectionViewHeader.swift
//  HeroSearch
//
//  Created by Ofir Elias on 12/05/2021.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {

	let label: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 18.0)
		label.tintColor = .white
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	
		addSubview(label)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		label.frame = bounds
	}
}
