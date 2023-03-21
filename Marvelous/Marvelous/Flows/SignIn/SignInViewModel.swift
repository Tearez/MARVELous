//
//  SignInViewModel.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import Foundation
import UIKit

final class SignInViewModel: ObservableObject {
	private let keychainSetter: KeychainAccessSetterProtocol
	private let keychainFetcher: KeychainAccessFetcherProtocol
    private let router: Router

	@MainActor
	@Published var publicKey: String = ""
	@MainActor
	@Published var privateKey: String = ""
	@MainActor
	@Published var errorMessage: String?

	init(keychainSetter: KeychainAccessSetterProtocol,
		 keychainFetcher: KeychainAccessFetcherProtocol,
         router: Router) {
		self.keychainSetter = keychainSetter
		self.keychainFetcher = keychainFetcher
        self.router = router
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

	func didSignIn() {
        router.showModal(transition: .move(edge: .bottom),
                         animation: .easeIn,
                         alignment: .bottom,
                         backgroundColor: .blue.opacity(0.2),
                         backgroundEffect: .init(
                            effect: UIBlurEffect(style: .systemMaterialDark),
                            opacity: 0.85
                         ),
                         useDeviceBounds: true,
                         modalType: .example)
	}

	@MainActor func resetError() {
		errorMessage = nil
	}
}
