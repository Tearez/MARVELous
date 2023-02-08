//
//  SignInBuilder.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 7.02.23.
//

import SwiftUI

protocol SignInDependency: HasKeychainSetter,
						   HasKeychainAccessFetcher {}

enum SignInAction {
	case signInSuccessfully
}

protocol SignInBuildable: Buildable {
	func build(action: @escaping (SignInAction) -> Void) -> SignInScreen
}

final class SignInBuilder: Builder<SignInDependency>, SignInBuildable {
	func build(action: @escaping (SignInAction) -> Void) -> SignInScreen {
		let viewModel = SignInViewModel(keychainSetter: dependency.keychainSetter,
										keychainFetcher: dependency.keychainFetcher)
		return SignInScreen(viewModel: viewModel, action: action)
	}
}
