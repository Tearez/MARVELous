//
//  StorageProviders.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 7.02.23.
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class StorageAssembly: Assembly {
	func assemble(container: Swinject.Container) {
		container.autoregister(StorageProviderProtocol.self, initializer: LocalStorageProvider.init)
			.inObjectScope(.container)
		container.autoregister(ConfigurationProviderProtocol.self, initializer: ConfigurationProvider.init)
			.inObjectScope(.container)
		container.autoregister(KeychainAccessFetcherProtocol.self, initializer: KeychainAccess.init)
			.inObjectScope(.container)
		container.autoregister(KeychainAccessSetterProtocol.self, initializer: KeychainAccess.init)
			.inObjectScope(.container)
	}
}
