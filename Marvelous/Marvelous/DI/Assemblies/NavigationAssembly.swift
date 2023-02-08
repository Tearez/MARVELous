//
//  NavigationAssembly.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 8.02.23.
//

import SwiftUI
import Swinject
import SwinjectAutoregistration

final class NavigationAssembly: Assembly {
	func assemble(container: Swinject.Container) {
		container.register(NavigationPath.self) { _ in
			NavigationPath()
		}.inObjectScope(.container)
	}
}
