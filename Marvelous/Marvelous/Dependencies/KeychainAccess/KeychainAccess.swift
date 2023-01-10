//
//  KeychainAccess.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 22.07.22.
//

import KeychainAccess
import Combine

struct KeychainAccessAPIKeys {
	let publicKey: String
	let privateKey: String
}

enum KeychainAccessSetterType {
	case privateKey(String)
	case publicKey(String)
}

struct KeychainAccessError: Error {
	enum KeychainAccessErrorType {
		case fetchingKeys
		case settingProperty(KeychainAccessSetterType)
		case unknown
	}

	let description: String
	private let type: KeychainAccessErrorType

	private init(description: String, type: KeychainAccessErrorType = .unknown) {
		self.description = description
		self.type = type
	}

	static func error(for type: KeychainAccessErrorType) -> Self {
		switch type {
			case .fetchingKeys:
			return Self.init(description: "keychain_error_fetching_keys".localized(), type: type)
			case .settingProperty(let keychainAccessSetterType):
				switch keychainAccessSetterType {
					case .publicKey:
						return Self.init(description: "keychain_error_public_key".localized(), type: type)
					case .privateKey:
					return Self.init(description: "keychain_error_private_key".localized(), type: type)
				}
			case .unknown:
			return Self.init(description: "keychain_error_unknown".localized())
		}
	}
}

extension KeychainAccessError: LocalizedError {
	public var errorDescription: String? {
		self.description
	}
}

protocol KeychainAccessFetcherProtocol {
	func fetchAPIKeys() throws -> KeychainAccessAPIKeys
}

protocol KeychainAccessSetterProtocol {
	func setProperty(_ type: KeychainAccessSetterType) async throws -> Void
}

final class KeychainAccess: KeychainAccessFetcherProtocol, KeychainAccessSetterProtocol {
	private enum StoreKeys {
		static let keychainService = "com.tearez.tests.marvelous.keychain"
		static let publicKeySecret = "marvelous.keychain.public.key.secret"
		static let privateKeySecret = "marvelous.keychain.private.key.secret"
	}
	private let keychain = Keychain(service: StoreKeys.keychainService)

	func fetchAPIKeys() throws -> KeychainAccessAPIKeys {
		do {
			let privateKey = try keychain.getString(StoreKeys.privateKeySecret)
			let publicKey = try keychain.getString(StoreKeys.publicKeySecret)
			guard let unwrapedPrivateKey = privateKey,
				  let unwrappedPublicKey = publicKey else {
				throw KeychainAccessError.error(for: .fetchingKeys)
			}

			return .init(publicKey: unwrappedPublicKey, privateKey: unwrapedPrivateKey)
		} catch {
			throw KeychainAccessError.error(for: .fetchingKeys)
		}
	}

	func setProperty(_ type: KeychainAccessSetterType) async throws {
		do {
			switch type {
				case .privateKey(let privateKey):
					try keychain.set(privateKey, key: StoreKeys.privateKeySecret)
				case .publicKey(let publicKey):
					try keychain.set(publicKey, key: StoreKeys.publicKeySecret)
			}
			throw KeychainAccessError.error(for: .settingProperty(type))
		} catch {
			throw KeychainAccessError.error(for: .settingProperty(type))
		}
	}
}
