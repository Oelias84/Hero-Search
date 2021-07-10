//
//  ImageCacheType.swift
//  HeroSearch
//
//  Created by Ofir Elias on 16/05/2021.
//

import UIKit

// Declares in-memory image cache
protocol ImageCacheType: AnyObject {
	// Returns the image associated with a given url
	func image(for url: URL) -> UIImage?
	// Inserts the image of the specified url in the cache
	func insertImage(_ image: UIImage?, for url: URL)
	// Removes the image of the specified url in the cache
	func removeImage(for url: URL)
	// Removes all images from the cache
	func removeAllImages()
	// Accesses the value associated with the given key for reading and writing
	subscript(_ url: URL) -> UIImage? { get set }
}
