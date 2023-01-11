//
//  HasDependencyDefinition.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import Foundation

protocol HasKeychainSetter {
	var keychainSetter: KeychainAccessSetterProtocol { get }
}

protocol HasKeychainAccessFetcher {
	var keychainFetcher: KeychainAccessFetcherProtocol { get }
}

protocol HasSecretEncryptor {
	var secretEncryptor: SecretEncryptorProtocol { get }
}

protocol HasConfigurationProvider {
	var configurationProvider: ConfigurationProviderProtocol { get }
}
