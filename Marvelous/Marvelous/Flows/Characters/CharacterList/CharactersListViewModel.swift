//
//  CharactersListViewModel.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 11.01.23.
//

import Foundation

protocol CharactersListDependency: HasImageUrlBuilder {
	var webService: GetAllCharactersWebServiceProtocol { get }
}

struct CharactersListModel: Identifiable {
	let id: Int
	let name: String
	let description: String?
	let thumbnailUrl: URL?
}

final class CharactersListViewModel: ObservableObject {
	private enum Constants {
		static let limit: Int = 20
		static let offset: Int = 5
	}

	private let webService: GetAllCharactersWebServiceProtocol
	private let imageUrlBuilder: ImageUrlBuilderProtocol

	@MainActor
	@Published private(set) var models: [CharactersListModel] = []

	private var totalItems = 0
	private var page : Int = 1

	init(dependency: CharactersListDependency) {
		webService = dependency.webService
		imageUrlBuilder = dependency.imageUrlBuilder
	}

	//MARK: - PAGINATION
	func loadMoreContent(current model: CharactersListModel) {
		Task {
			let models = await self.models
			guard models.count > Constants.offset else {
				return
			}
			let thresholdItem = models[models.endIndex - Constants.offset]
			let offsetItemCount = (page * Constants.limit) + Constants.offset
			if thresholdItem.id == model.id, offsetItemCount <= totalItems {
				page += 1

				await getAll()
			}
		}
	}

	func getAll() async {
		do {
			let result = try await webService.getAllCharacters(limit: Constants.limit, offset: Constants.limit * (page - 1))
			totalItems = result.data?.total ?? .zero

			guard let results = result.data?.results else {
				return
			}

			let mappedResults: [CharactersListModel] = results.compactMap({ item in
				if let id = item.id, let name = item.name {
					let thumbnailUrl: URL? = self.imageUrlBuilder.buildUrl(from: item.thumbnail?.path, item.thumbnail?.thumbnailExtension?.rawValue)
					return CharactersListModel(id: id,
											   name: name,
											   description: item.resultDescription,
											   thumbnailUrl: thumbnailUrl)
				} else {
					return nil
				}
			})

			await MainActor.run(body: {
				models.append(contentsOf: mappedResults)
			})

		} catch let error {
			print(error.localizedDescription)
		}
	}
}
