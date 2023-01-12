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

		container.register(ImageUrlBuilderProtocol.self) { _ in
			ImageUrlBuilder()
		}.inObjectScope(.transient)
	}
}

extension DependencyContainer: HasKeychainAccessFetcher,
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
}

extension DependencyContainer: SignInDependency {
	var keychainSetter: KeychainAccessSetterProtocol {
		container.resolve(KeychainAccessSetterProtocol.self)!
	}
}

extension DependencyContainer: CharactersListDependency {
	var imageUrlBuilder: ImageUrlBuilderProtocol {
		container.resolve(ImageUrlBuilderProtocol.self)!
	}

	var webService: GetAllCharactersWebServiceProtocol {
		WebService(configurationProvider: configurationProvider,
				   keychainAccessFetcher: keychainFetcher,
				   secretEncryptor: secretEncryptor)
	}
}

