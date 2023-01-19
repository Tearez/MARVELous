//
//  CharactersRouter.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 13.01.23.
//

import SwiftUI

struct CharactersRouter: View {
	private enum CharactersDestination: Hashable {
		case list
		case details
	}

	@State private var navigationPath: NavigationPath
	@State private var destinationToPresentModaly: CharactersDestination?

	init() {
		self._navigationPath = .init(wrappedValue: NavigationPath())
	}

	var body: some View {
		NavigationStack(path: $navigationPath) {
			CharactersListScreen()
				.sheet(isPresented: .constant(destinationToPresentModaly != nil),
					   onDismiss: {
					destinationToPresentModaly = nil
				}, content: {
					if let destination = destinationToPresentModaly {
						self.handle(destination)
					}
				})
				.navigationDestination(for: CharactersDestination.self) { destination in
					self.handle(destination)
						.toolbarBackground(.hidden, for: .navigationBar)
				}
		}
	}

	@ViewBuilder private func handle(_ destination: CharactersDestination) -> some View {
		switch destination {
		case .list:
			CharactersListScreen()
		case .details:
			EmptyView()
		}
	}
}
