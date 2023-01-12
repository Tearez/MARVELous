//
//  CharacterResponse.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 5.07.22.
//

import Foundation

// MARK: - CharacterResponse
struct CharacterResponse: Codable {
	let id: Int?
	let name: String?
	let resultDescription: String?
	let modified: String?
	let thumbnail: ThumbnailResponse?
	let resourceURI: String?
	let comics: ComicsResponse?
	let series: ComicsResponse?
	let stories: StoriesResponse?
	let events: ComicsResponse?
	let urls: [URLElement]?

	private enum CodingKeys: String, CodingKey {
		case id, name
		case resultDescription = "description"
		case modified, thumbnail, resourceURI, comics, series, stories, events, urls
	}
}

// MARK: - ComicsResponse
struct ComicsResponse: Codable {
	let available: Int?
	let collectionURI: String?
	let items: [ComicsItemResponse]?
	let returned: Int?
}

// MARK: - ComicsItemResponse
struct ComicsItemResponse: Codable {
	let resourceURI: String?
	let name: String?
}

// MARK: - Stories
struct StoriesResponse: Codable {
	let available: Int?
	let collectionURI: String?
	let items: [StoryResponse]?
	let returned: Int?
}

// MARK: - StoriesItem
struct StoryResponse: Codable {
	let resourceURI: String?
	let name: String?
}

// MARK: - Thumbnail
struct ThumbnailResponse: Codable {
	let path: String?
	let thumbnailExtension: Extension?

	enum CodingKeys: String, CodingKey {
		case path
		case thumbnailExtension = "extension"
	}
}

enum Extension: String, Codable {
	case gif = "gif"
	case jpg = "jpg"
}

// MARK: - URLElement
struct URLElement: Codable {
	let type: URLType?
	let url: String?
}

enum URLType: String, Codable {
	case comiclink = "comiclink"
	case detail = "detail"
	case wiki = "wiki"
}
