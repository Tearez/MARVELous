//
//  DependencyContainer+Screens.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import Foundation

extension DependencyContainer: SignInDependency {}

extension DependencyContainer: CharactersListDependency {
	var webService: GetAllCharactersWebServiceProtocol {
		WebService(configurationProvider: configurationProvider,
				   keychainAccessFetcher: keychainFetcher,
				   secretEncryptor: secretEncryptor)
	}
}
