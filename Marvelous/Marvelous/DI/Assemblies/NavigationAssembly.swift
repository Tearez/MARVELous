//
//  NavigationAssembly.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 8.02.23.
//

import SwiftUI
import Swinject
import SwinjectAutoregistration

enum RootDestination: Hashable {
	case auth
	case home
}

protocol Navigatable {
	func switchRoot(_ newRoot: RootDestination)
	func push(_ destination: any Hashable)
	func remove(amount: Int)
	func removeAll()
}

protocol Pathable {
	var path: NavigationPath { get set }
}

final class NavigationAssembly: Assembly {
	func assemble(container: Swinject.Container) {
		container.register(RootRouterInteractor.self) { _ in
			RootRouterInteractor()
		}.inObjectScope(.container)

		container.register(Navigatable.self) { resolver in
			resolver.resolve(RootRouterInteractor.self)!
		}.inObjectScope(.container)
	}
}
