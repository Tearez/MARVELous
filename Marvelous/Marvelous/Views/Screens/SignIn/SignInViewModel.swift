//
//  SignInViewModel.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import Foundation

protocol SignInDependency: HasKeychainSetter {}

final class SignInViewModel: SignInDependency, ObservableObject {
	let keychainSetter: KeychainAccessSetterProtocol

	@Published var publicKey: String = ""
	@Published var privateKey: String = ""

	init(dependency: SignInDependency) {
		self.keychainSetter = dependency.keychainSetter
	}

	func signIn() {
		keychainSetter.setProperty(for: .publicKey(publicKey)) { result in
			switch result {
			case .success:
				print("SET SUCCESS PUBLIC")
			case .error(let error):
				print("SET ERROR PUBLIC \(error.localizedDescription)")
			}
		}
		keychainSetter.setProperty(for: .privateKey(privateKey)) { result in
			switch result {
			case .success:
				print("SET SUCCESS PRIVATE")
			case .error(let error):
				print("SET ERROR PRIVATE \(error.localizedDescription)")
			}
		}
	}
}
