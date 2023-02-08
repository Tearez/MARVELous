//
//  HelperAssembly.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 7.02.23.
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class HelperAssembly: Assembly {
	func assemble(container: Swinject.Container) {
		container.register(Bundle.self) { _ in
			Bundle.main
		}.inObjectScope(.container)

		container.register(UserDefaults.self) { _ in
			UserDefaults.standard
		}.inObjectScope(.container)

		container.autoregister(SecretEncryptorProtocol.self, initializer: SecretEncryptor.init)
			.inObjectScope(.transient)
		container.autoregister(ImageUrlBuilderProtocol.self, initializer: ImageUrlBuilder.init)
			.inObjectScope(.transient)
	}
}
