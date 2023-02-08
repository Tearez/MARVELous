//
//  SignInViewModel.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import Foundation

final class SignInViewModel: ObservableObject {
	private let keychainSetter: KeychainAccessSetterProtocol
	private let keychainFetcher: KeychainAccessFetcherProtocol

	@MainActor
	@Published var publicKey: String = ""
	@MainActor
	@Published var privateKey: String = ""
	@MainActor
	@Published var errorMessage: String?

	init(keychainSetter: KeychainAccessSetterProtocol,
		 keychainFetcher: KeychainAccessFetcherProtocol) {
		self.keychainSetter = keychainSetter
		self.keychainFetcher = keychainFetcher
	}

	func checkKeychainStore() async {
		guard let keys = try? keychainFetcher.fetchAPIKeys() else {
			return
		}
		await MainActor.run(body: {
			publicKey = keys.publicKey
			privateKey = keys.privateKey
		})
	}

	func signIn() async {
		do {
			try await withThrowingTaskGroup(of: Void.self, returning: Void.self) { taskGroup in
				taskGroup.addTask() {
					try await self.keychainSetter.setProperty(.publicKey(self.publicKey))
				}
				taskGroup.addTask() {
					try await self.keychainSetter.setProperty(.privateKey(self.privateKey))
				}

				return try await taskGroup.waitForAll()
			}
		} catch let error {
			await MainActor.run(body: {
				errorMessage = error.localizedDescription
			})
		}
	}

	@MainActor func resetError() {
		errorMessage = nil
	}
}
