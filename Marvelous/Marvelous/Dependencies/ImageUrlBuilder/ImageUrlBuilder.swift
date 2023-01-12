//
//  ImageUrlBuilder.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 12.01.23.
//

import Foundation

protocol ImageUrlBuilderProtocol {
	func buildUrl(from path: String?, _ pathExtension: String?) -> URL?
}

final class ImageUrlBuilder: ImageUrlBuilderProtocol {
	func buildUrl(from path: String?, _ pathExtension: String?) -> URL? {
		guard let path = path else {
			return nil
		}
		if let pathExtension = pathExtension {
			return URL(string: path + "." + pathExtension)
		} else {
			return URL(string: path)
		}
	}
}
