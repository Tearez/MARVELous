//
//  MainCoordinator.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 10.01.23.
//

import SwiftUI

struct Builders {
	let signInBuildable: any SignInBuildable
}

struct RootRouter: View {

	private let builders: Builders

	@StateObject private var interactor: RootRouterInteractor

	init(builders: Builders, interactor: RootRouterInteractor) {
		self.builders = builders
		self._interactor = .init(wrappedValue: interactor)
	}

	var body: some View {
		NavigationStack(path: $interactor.path) {
			singInScreen
				.navigationDestination(for: RootDestination.self) { destination in
					self.handle(destination)
				}
		}
	}

	@ViewBuilder private func handle(_ destination: RootDestination) -> some View {
		switch destination {
		case .auth:
			singInScreen
		case .home:
			CharactersListScreen()
			.toolbar(.hidden, for: .navigationBar)
		}
	}

	var singInScreen: some View {
		builders.signInBuildable.build()
	}

	private func handleSignInAction(_ action: SignInAction) {
		interactor.push(RootDestination.home)
	}
}
