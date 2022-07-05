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

	init(apiClient: BaseNetworkClient,
		 configurationProvider: ConfigurationProviderProtocol) {
		self.apiClient = apiClient
		self.configurationProvider = configurationProvider
	}

	func getAllCharacters() -> AnyPublisher<CommonResponseContainer<PagedResponse<CharacterResposne>>, Error> {
		return apiClient.request(
			url: buildUrl(for: "/v1/public/characters"),
			method: .get,
			parameters: Params(
				apikey: publicKey,
				hash: Insecure.MD5.hash(data: (timeStamp + privateKey + publicKey).data(using: .utf8) ?? Data()).map { String(format: "%02hhx", $0) }.joined()
			)
		).eraseToAnyPublisher()
	}

	private func buildUrl(for path: String) -> String {
		return configurationProvider.baseUrl.appending(path)
	}
}
