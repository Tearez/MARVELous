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
		keychainAccess
			.setProperty(for: .publicKey("e86a88ebcd504643272e60df0521338b")) { result in
				switch result {
					case .success:
						print("SET SUCCESS PUBLIC")
					case .error(let error):
						print("SET ERROR PUBLIC \(error.localizedDescription)")
				}
			}
		keychainAccess
			.setProperty(for: .privateKey("4a3077ba44adbfe153f98175ee0bcf2a03bd6a2b")) { result in
				switch result {
					case .success:
						print("SET SUCCESS PRIVATE")
					case .error(let error):
						print("SET ERROR PRIVATE \(error.localizedDescription)")
				}
			}
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
    var body: some Scene {
        WindowGroup {
			SwiftUIView()
		}
    }
}
