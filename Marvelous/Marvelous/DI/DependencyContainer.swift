//
//  ViewModelFactory.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 30.01.22.
//

import Foundation
import SwiftUI
import Swinject

protocol MainDependency: HasKeychainSetter,
						 HasKeychainAccessFetcher,
						 HasSecretEncryptor,
						 HasConfigurationProvider,
						 HasImageUrlBuilder {}

final class DependencyContainer {
	static let shared: DependencyContainer = .init()

	private let container: Container = .init()
	private let assembler: Assembler

	init() {
		assembler = .init(
			[
				HelperAssembly(),
				StorageAssembly(),
				NetworkAssembly()
			],
			container: container
		)
	}
}

extension DependencyContainer: MainDependency {
	var keychainFetcher: KeychainAccessFetcherProtocol {
		container.resolve(KeychainAccessFetcherProtocol.self)!
	}

	var keychainSetter: KeychainAccessSetterProtocol {
		container.resolve(KeychainAccessSetterProtocol.self)!
	}

	var secretEncryptor: SecretEncryptorProtocol {
		container.resolve(SecretEncryptorProtocol.self)!
	}

	var configurationProvider: ConfigurationProviderProtocol {
		container.resolve(ConfigurationProviderProtocol.self)!
	}

	var imageUrlBuilder: ImageUrlBuilderProtocol {
		container.resolve(ImageUrlBuilderProtocol.self)!
	}
}

extension DependencyContainer: SignInDependency {}

extension DependencyContainer: CharactersListDependency {
	var webService: GetAllCharactersWebServiceProtocol {
		container.resolve(GetAllCharactersWebServiceProtocol.self)!
	}
}

