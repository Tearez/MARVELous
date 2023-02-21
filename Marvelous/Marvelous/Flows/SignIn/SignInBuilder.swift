//
//  SignInBuilder.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 7.02.23.
//

import SwiftUI

protocol SignInDependency: HasKeychainSetter,
						   HasKeychainAccessFetcher,
						   HasNavigator {}

enum SignInAction {
	case signInSuccessfully
}

protocol SignInBuildable: Buildable {
	func build() -> SignInScreen
}

final class SignInBuilder: Builder<SignInDependency>, SignInBuildable {
	func build() -> SignInScreen {
		let viewModel = SignInViewModel(keychainSetter: dependency.keychainSetter,
										keychainFetcher: dependency.keychainFetcher,
										navigator: dependency.navigator)
		return SignInScreen(viewModel: viewModel)
	}
}
