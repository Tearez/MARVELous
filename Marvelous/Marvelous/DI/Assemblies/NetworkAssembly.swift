//
//  NetworkAssembly.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 7.02.23.
//

import Swinject
import SwinjectAutoregistration

final class NetworkAssembly: Assembly {
	func assemble(container: Swinject.Container) {
		container.autoregister(GetAllCharactersWebServiceProtocol.self, initializer: WebService.init)
			.inObjectScope(.transient)
	}
}
