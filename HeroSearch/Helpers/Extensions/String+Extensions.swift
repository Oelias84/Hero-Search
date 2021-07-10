//
//  String+Extensions.swift
//  HeroSearch
//
//  Created by Ofir Elias on 15/05/2021.
//

import UIKit

extension String {
	
	var checkNull: String {
		return self == "null" ? "-" : self
	}
}
