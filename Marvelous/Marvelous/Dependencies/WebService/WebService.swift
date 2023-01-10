//
//  WebService.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 3.07.22.
//

import Combine
import Foundation
import CryptoKit

struct Params: Encodable {
	let apikey: String
	let hash: String
	let ts: String = Date().ISO8601Format()
}

struct EmptyResponse: Decodable {}

class WebService {
	private let apiClient: BaseNetworkClient
	private let configurationProvider: ConfigurationProviderProtocol
	private let keychainAccessFetcher: KeychainAccessFetcherProtocol
	private let secretEncryptor: SecretEncryptorProtocol

	init(configurationProvider: ConfigurationProviderProtocol,
		 keychainAccessFetcher: KeychainAccessFetcherProtocol,
		 secretEncryptor: SecretEncryptorProtocol) {
		self.apiClient = BaseNetworkClient()
		self.configurationProvider = configurationProvider
		self.keychainAccessFetcher = keychainAccessFetcher
		self.secretEncryptor = secretEncryptor
	}

//	func getAllCharacters() -> AnyPublisher<CommonResponseContainer<PagedResponse<CharacterResposne>>, Error> {
//		return CurrentValueSubject<KeychainAccessActionResult<KeychainAccessAPIKeys>, Error>.init(keychainAccessFetcher.fetchAPIKeys())
//			.eraseToAnyPublisher()
//			.tryMap { result -> KeychainAccessAPIKeys in
//				switch result {
//					case .success(let keys):
//						return keys
//					case .error(let error):
//						throw error
//				}
//			}
//			.flatMap(maxPublishers: .max(1), { apiKeys -> AnyPublisher<CommonResponseContainer<PagedResponse<CharacterResposne>>, Error> in
//				let hash = self.secretEncryptor.encryptWebServiceHash(for: apiKeys.privateKey, publicKey: apiKeys.publicKey)
//
//				return self.apiClient
//					.request(url: self.buildUrl(for: "/v1/public/characters"),
//							 method: .get,
//							 parameters: Params(apikey: apiKeys.publicKey, hash: hash))
//			})
//			.eraseToAnyPublisher()
//	}

	private func buildUrl(for path: String) -> String {
		return configurationProvider.baseUrl.appending(path)
	}
}
