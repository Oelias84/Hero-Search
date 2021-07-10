//
//  Alerts.swift
//  HeroSearch
//
//  Created by Ofir Elias on 13/05/2021.
//

import UIKit

class Alerts {
	
	static func invalidSearchAlert(completion: @escaping () -> ()) -> UIAlertController {
		let alert = UIAlertController(title: "Oops!", message: "In order to search for your favorite super heroes please specify at least 3 characters", preferredStyle: .alert)
		alert.addAction(.init(title: "Got it", style: .cancel, handler: { _ in
			completion()
		}))
		return alert
	}
	static func networkErrorAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(.init(title: "Ok", style: .cancel))
		
		if var topController = UIApplication.shared.windows.first?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			topController.present(alert, animated: true, completion: nil)
		}
	}
}
