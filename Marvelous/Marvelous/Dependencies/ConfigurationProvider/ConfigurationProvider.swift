//
//  ConfigurationProvider.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 1.02.22.
//

import Foundation

protocol ConfigurationProviderProtocol {
	var baseUrl: String { get }
}

final class ConfigurationProvider: ConfigurationProviderProtocol {

	let bundle: Bundle

	init(bundle: Bundle) {
		self.bundle = bundle
	}

	var baseUrl: String {
		return readProperty(for: "BASE_URL")
	}

	private func readProperty<T>(for key: String) -> T {
		guard let object = bundle.object(forInfoDictionaryKey: key) else {
			fatalError("Value does not exist for key: \(key)")
		}

		switch object {
			case let value as T:
				return value
			default:
				fatalError("Value for key \(key) is not of type \(T.self)")
		}
	}
}
