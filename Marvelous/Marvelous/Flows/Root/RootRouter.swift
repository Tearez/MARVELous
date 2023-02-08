//
//  MainCoordinator.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 10.01.23.
//

import SwiftUI

enum NavigationStep {
	case pop
	case push
	case popToRoot
}

enum RootDestination: Hashable {
	case auth
	case home
}

struct RootRouter: View {
	private struct Builders {
		let signInBuildable: any SignInBuildable
	}

	private let builders: Builders

	@State private var navigationPath: NavigationPath

	init() {
		let dependency = DependencyContainer()
		self.builders = .init(signInBuildable: SignInBuilder(dependency: dependency))
		self._navigationPath = .init(wrappedValue: dependency.navigationPath)
	}

	var body: some View {
		NavigationStack(path: $navigationPath) {
			builders.signInBuildable.build(action: { action in handleSignInAction(action) })
				.navigationDestination(for: RootDestination.self) { destination in
					self.handle(destination)
				}
		}
	}

	@ViewBuilder private func handle(_ destination: RootDestination) -> some View {
		switch destination {
		case .auth:
			builders.signInBuildable.build(action: { action in handleSignInAction(action) })
		case .home:
			CharactersListScreen()
			.toolbar(.hidden, for: .navigationBar)
		}
	}

	var singInScreen: some View {
		builders.signInBuildable.build(action: { action in handleSignInAction(action) })
	}

	private func handleSignInAction(_ action: SignInAction) {
		navigationPath.append(RootDestination.home)
	}
}
