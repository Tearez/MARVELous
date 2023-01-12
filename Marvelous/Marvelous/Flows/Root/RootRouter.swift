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

struct RootRouter: View {
	private enum RootDestination: Hashable {
		case auth
		case home
	}

	@State private var navigationPath: NavigationPath

	init() {
		self._navigationPath = .init(wrappedValue: NavigationPath())
	}

	var body: some View {
		NavigationStack(path: $navigationPath) {
			SignInScreen(action: { action in handleSignInAction(action) })
			.navigationDestination(for: RootDestination.self) { destination in
				self.handle(destination)
			}
		}
	}

	@ViewBuilder private func handle(_ destination: RootDestination) -> some View {
		switch destination {
		case .auth:
			SignInScreen(action: { action in handleSignInAction(action) })
		case .home:
			CharactersListScreen()
			.toolbar(.hidden, for: .navigationBar)
		}
	}

	private func handleSignInAction(_ action: SignInAction) {
		navigationPath.append(RootDestination.home)
	}
}