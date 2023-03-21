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
    func build(router: Router) -> SignInScreen
}

final class SignInBuilder: Builder<SignInDependency>, SignInBuildable {
    func build(router: Router) -> SignInScreen {
		let viewModel = SignInViewModel(keychainSetter: dependency.keychainSetter,
										keychainFetcher: dependency.keychainFetcher,
                                        router: router)
		return SignInScreen(viewModel: viewModel)
	}
}
