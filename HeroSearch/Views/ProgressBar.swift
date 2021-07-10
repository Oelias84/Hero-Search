//
//  ProgresBar.swift
//  HeroSearch
//
//  Created by Ofir Elias on 14/05/2021.
//

import UIKit

@IBDesignable
class ProgressBar: UIView {
	
	@IBInspectable var color: UIColor = .gray {
		didSet { setNeedsDisplay() }
	}

	var progress: CGFloat = 0 {
		didSet { setNeedsDisplay() }
	}

	private let progressLayer = CALayer()
	private let backgroundMask = CAShapeLayer()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLayers()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupLayers()
	}

	private func setupLayers() {
		layer.addSublayer(progressLayer)
	}

	override func draw(_ rect: CGRect) {
		backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height/2).cgPath
		layer.mask = backgroundMask

		let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * (progress/100), height: rect.height))

		progressLayer.frame = progressRect
		progressLayer.backgroundColor = color.cgColor
	}
}
