//
//  UIViewController+Extensions.swift
//  HeroSearch
//
//  Created by Ofir Elias on 15/05/2021.
//

import UIKit
import iProgressHUD

extension UIViewController {
	
	// Setup loading progress HUD
	var progressSpinner: iProgressHUD {
		let progress = iProgressHUD.sharedInstance()
		
		progress.indicatorColor = .red
		progress.boxSize = 40
		progress.boxCorner = 13
		progress.captionSize = 16
		progress.boxColor = .tertiarySystemGroupedBackground
		progress.modalColor = .clear
		progress.alphaModal = 1
		progress.indicatorStyle = .triangleSkewSpin
		return progress
	}
}
