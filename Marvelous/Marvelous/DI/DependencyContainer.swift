//
//  ViewModelFactory.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 30.01.22.
//

import Foundation
import Swinject

final class DependencyContainer {
	static let shared: DependencyContainer = .init()

	private let container: Container = .init()

	private init() {
		register()
	}

	private func register() {
		container.register(KeychainAccessSetterProtocol.self) { _ in
			KeychainAccess()
		}.inObjectScope(.container)

		container.register(KeychainAccessFetcherProtocol.self) { _ in
			KeychainAccess()
		}.inObjectScope(.container)

		container.register(SecretEncryptorProtocol.self) { _ in
			SecretEncryptor()
		}.inObjectScope(.container)

		container.register(ConfigurationProviderProtocol.self) { _ in
			ConfigurationProvider()
		}.inObjectScope(.container)
	}
}

extension DependencyContainer: HasKeychainSetter,
							   HasKeychainAccessFetcher,
							   HasSecretEncryptor,
							   HasConfigurationProvider {
	var keychainFetcher: KeychainAccessFetcherProtocol {
		container.resolve(KeychainAccessFetcherProtocol.self)!
	}
	
	var secretEncryptor: SecretEncryptorProtocol {
		container.resolve(SecretEncryptorProtocol.self)!
	}
	
	var configurationProvider: ConfigurationProviderProtocol {
		container.resolve(ConfigurationProviderProtocol.self)!
	}
	
	var keychainSetter: KeychainAccessSetterProtocol {
		container.resolve(KeychainAccessSetterProtocol.self)!
	}
}


