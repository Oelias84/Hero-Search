//
//  ImageCache.swift
//  HeroSearch
//
//  Created by Ofir Elias on 16/05/2021.
//

import UIKit

public final class ImageCache: ImageCacheType {

	// First level cache, that contains encoded images
	private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
		let cache = NSCache<AnyObject, AnyObject>()
		cache.countLimit = config.countLimit
		return cache
	}()
	// Second level cache, that contains decoded images
	private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
		let cache = NSCache<AnyObject, AnyObject>()
		cache.totalCostLimit = config.memoryLimit
		return cache
	}()
	
	private let config: Config

	public struct Config {
		public let countLimit: Int
		public let memoryLimit: Int

		public static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
	}

	public init(config: Config = Config.defaultConfig) {
		self.config = config

		// Clean cache after one day

		DispatchQueue.main.asyncAfter(deadline: .now() + (60*60*24)) {
			self.removeAllImages()
		}
	}
	public func image(for url: URL) -> UIImage? {

		// The best case scenario -> there is a decoded image in memory
		if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
			return decodedImage
		}
		// Search for image data
		if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
			let decodedImage = image.decodedImage()
			decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
			return decodedImage
		}
		return nil
	}
	public func insertImage(_ image: UIImage?, for url: URL) {
		guard let image = image else { return removeImage(for: url) }
		let decompressedImage = image.decodedImage()

		imageCache.setObject(decompressedImage, forKey: url as AnyObject, cost: 1)
		decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decompressedImage.diskSize)
	}
	public func removeImage(for url: URL) {
		imageCache.removeObject(forKey: url as AnyObject)
		decodedImageCache.removeObject(forKey: url as AnyObject)
	}
	public func removeAllImages() {
		imageCache.removeAllObjects()
		decodedImageCache.removeAllObjects()
	}
	
	public subscript(_ key: URL) -> UIImage? {
		get {
			return image(for: key)
		}
		set {
			return insertImage(newValue, for: key)
		}
	}
}

fileprivate extension UIImage {
	
	// Decompress Image (for more aficciant )
	func decodedImage() -> UIImage {
		guard let cgImage = cgImage else { return self }
		let size = CGSize(width: cgImage.width, height: cgImage.height)
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
		context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
		guard let decodedImage = context?.makeImage() else { return self }
		return UIImage(cgImage: decodedImage)
	}
	// Rough estimation of how much memory image uses in bytes
	var diskSize: Int {
		guard let cgImage = cgImage else { return 0 }
		return cgImage.bytesPerRow * cgImage.height
	}
}
