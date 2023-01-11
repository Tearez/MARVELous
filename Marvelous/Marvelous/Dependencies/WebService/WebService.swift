//
//  WebService.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 3.07.22.
//

import Alamofire
import Combine
import Foundation
import CryptoKit

struct GetAllCharactersParams: Encodable {
	let apikey: String
	let hash: String
	let ts: String = Date().ISO8601Format()
	let limit: Int
	let offset: Int
}

struct EmptyResponse: Decodable {}

protocol GetAllCharactersWebServiceProtocol {
	func getAllCharacters(limit: Int, offset: Int) async throws -> CommonResponseContainer<PagedResponse<CharacterResposne>>
}

final class WebService: GetAllCharactersWebServiceProtocol {
	private let configurationProvider: ConfigurationProviderProtocol
	private let keychainAccessFetcher: KeychainAccessFetcherProtocol
	private let secretEncryptor: SecretEncryptorProtocol

	init(configurationProvider: ConfigurationProviderProtocol,
		 keychainAccessFetcher: KeychainAccessFetcherProtocol,
		 secretEncryptor: SecretEncryptorProtocol) {
		self.configurationProvider = configurationProvider
		self.keychainAccessFetcher = keychainAccessFetcher
		self.secretEncryptor = secretEncryptor
	}

	func getAllCharacters(limit: Int, offset: Int) async throws -> CommonResponseContainer<PagedResponse<CharacterResposne>> {
		let apiKeys = try keychainAccessFetcher.fetchAPIKeys()
		let hash = secretEncryptor.encryptWebServiceHash(for: apiKeys.privateKey, publicKey: apiKeys.publicKey)

		guard let url = URL(string: buildUrl(for: "/v1/public/characters")) else {
			throw NSError(domain: "", code: 1)
		}

		let dataTask = AF.request(url,
								  method: .get,
								  parameters: GetAllCharactersParams(apikey: apiKeys.publicKey,
																	 hash: hash,
																	 limit: limit,
																	 offset: offset))
			.serializingDecodable(CommonResponseContainer<PagedResponse<CharacterResposne>>.self)

		return try await dataTask.value
	}

	private func buildUrl(for path: String) -> String {
		return configurationProvider.baseUrl.appending(path)
	}
}
