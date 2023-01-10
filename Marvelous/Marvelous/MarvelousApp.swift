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
	let keychainAccess = KeychainAccess()
	private lazy var webService = WebService(configurationProvider: ConfigurationProvider(),
										keychainAccessFetcher: keychainAccess,
										secretEncryptor: SecretEncryptor())

	func callService() {
//		webService.getAllCharacters()
//			.receive(on: DispatchQueue.main)
//			.sink(receiveCompletion: { completion in
//				switch completion {
//					case .finished:
//						print("SUCCESS 1")
//					case .failure(let error):
//						print("ERROR: \(error)")
//				}
//			}, receiveValue: { result in
//				print("SUCCESS \(result)")
//			})
//			.store(in: &storage)
	}
}

@main
struct MarvelousApp: App {
    var body: some Scene {
        WindowGroup {
			SwiftUIView()
		}
    }
}
