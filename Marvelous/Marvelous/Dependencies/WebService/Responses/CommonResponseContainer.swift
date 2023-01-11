//
//  CommonResponseContainer.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 5.07.22.
//

import Foundation

// MARK: - CommonResponseContainer
struct CommonResponseContainer<T:Codable>: Codable {
	let code: Int?
	let status, copyright, attributionText, attributionHTML: String?
	let etag: String?
	let data: T?
}

// MARK: - DataClass
struct PagedResponse<T:Codable>: Codable {
	let offset: Int?
	let limit: Int?
	let total: Int?
	let count: Int?
	let results: [T]?
}
