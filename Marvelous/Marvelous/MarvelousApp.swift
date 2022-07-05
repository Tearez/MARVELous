//
//  CryptoListApp.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 28.01.22.
//

import Combine
import SwiftUI

class VM {
	var storage: Set<AnyCancellable> = []
	private let webService = WebService(apiClient: BaseNetworkClient(),
										configurationProvider: ConfigurationProvider())

	func callService() {
		webService.getAllCharacters()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
					case .finished:
						print("SUCCESS 1")
					case .failure(let error):
						print("ERROR: \(error)")
				}
			}, receiveValue: { result in
				print("SUCCESS \(result)")
			})
			.store(in: &storage)
	}
}

@main
struct MarvelousApp: App {
	private let viewModelFactory = ViewModelFactory()

    var body: some Scene {
        WindowGroup {
			SwiftUIView()
		}
    }
}
