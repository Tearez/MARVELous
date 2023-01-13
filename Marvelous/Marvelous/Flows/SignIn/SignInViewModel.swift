//
//  SignInViewModel.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import Foundation

protocol SignInDependency: HasKeychainSetter,
						   HasKeychainAccessFetcher {}

final class SignInViewModel: SignInDependency, ObservableObject {
	let keychainSetter: KeychainAccessSetterProtocol
	let keychainFetcher: KeychainAccessFetcherProtocol

	@MainActor
	@Published var publicKey: String = ""
	@MainActor
	@Published var privateKey: String = ""
	@MainActor
	@Published var errorMessage: String?

	init(dependency: SignInDependency) {
		keychainSetter = dependency.keychainSetter
		keychainFetcher = dependency.keychainFetcher
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
