//
//  RootRouterInteractor.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 21.02.23.
//

import SwiftUI

final class RootRouterInteractor: Pathable, Navigatable, ObservableObject {
	@Published var path: NavigationPath = .init()

	func push(_ destination: any Hashable) {
		path.append(destination)
	}

	func remove(amount: Int) {
		path.removeLast(amount)
	}

	func switchRoot(_ newRoot: RootDestination) {
		// TODO: - Implement
	}

	func removeAll() {
		// TODO: - Implement
	}
}
