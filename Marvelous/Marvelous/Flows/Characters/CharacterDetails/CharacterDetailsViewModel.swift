//
//  CharacterDetailsViewModel.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 19.01.23.
//

import Foundation

final class CharacterDetailsViewModel: ObservableObject {
	private let model: CharactersListModel

	init(model: CharactersListModel) {
		self.model = model
	}

	var name: String {
		model.name
	}

	var description: String? {
		model.description
	}

	var updated: String? {
		model.updated
	}

	var thumbnailUrl: URL? {
		model.thumbnailUrl
	}

	var comics: [ComicModel] {
		model.comics ?? []
	}

	var stories: [ComicModel] {
		model.stories ?? []
	}

	var series: [ComicModel] {
		model.series ?? []
	}

	var events: [ComicModel] {
		model.events ?? []
	}
}
