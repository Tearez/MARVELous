//
//  CharactersListViewModel.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 11.01.23.
//

import Foundation

protocol CharactersListDependency {
	var webService: GetAllCharactersWebServiceProtocol { get }
}

struct CharactersListModel: Identifiable {
	let id: Int
	let name: String
}

final class CharactersListViewModel: ObservableObject {
	private enum Constants {
		static let limit: Int = 20
		static let offset: Int = 5
	}

	private let webService: GetAllCharactersWebServiceProtocol

	@MainActor
	@Published private(set) var models: [CharactersListModel] = []

	private var totalItems = 0
	private var page : Int = 1

	init(dependency: CharactersListDependency) {
		self.webService = dependency.webService
	}

	//MARK: - PAGINATION
	func loadMoreContent(current model: CharactersListModel) {
		Task {
			let models = await self.models
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

			await MainActor.run(body: {

				let mappedResult: [CharactersListModel?]? = result.data?.results?.compactMap {
					guard let id = $0.id, let name = $0.name else {
						return nil
					}
					return CharactersListModel(id: id, name: name)
				}

				if let unwrappedResult = mappedResult?.compactMap({ $0 }) {
					models.append(contentsOf: unwrappedResult)
				}
			})

		} catch let error {
			print(error.localizedDescription)
		}
	}
}
