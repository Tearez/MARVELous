//
//  KeychainAccess.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 22.07.22.
//

import KeychainAccess
import Combine

enum KeychainAccessActionResult<T> {
	case success(T)
	case error(Error)
}

typealias KeychainAccessSetterResultHandler = (KeychainAccessActionResult<Void>) -> Void

struct KeychainAccessAPIKeys {
	let publicKey: String
	let privateKey: String
}

enum KeychainAccessSetterType {
	case privateKey(String)
	case publicKey(String)
}

struct KeychainAccessError: LocalizedError {
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
				return Self.init(description: "Error occured while fetching API Keys", type: type)
			case .settingProperty(let keychainAccessSetterType):
				switch keychainAccessSetterType {
					case .publicKey(let key):
						return Self.init(description: "Error occured while setting public key with value: \(key)", type: type)
					case .privateKey(let key):
						return Self.init(description: "Error occured while setting private key with value: \(key)", type: type)
				}
			case .unknown:
				return Self.init(description: "Unknown error has occured")
		}
	}
}

protocol KeychainAccessFetcherProtocol {
	func fetchAPIKeys() -> KeychainAccessActionResult<KeychainAccessAPIKeys>
}

protocol KeychainAccessSetterProtocol {
	func setProperty(for type: KeychainAccessSetterType, resultHandler: @escaping KeychainAccessSetterResultHandler)
}

final class KeychainAccess: KeychainAccessFetcherProtocol, KeychainAccessSetterProtocol {
	private enum StoreKeys {
		static let keychainService = "com.tearez.tests.marvelous.keychain"
		static let publicKeySecret = "marvelous.keychain.public.key.secret"
		static let privateKeySecret = "marvelous.keychain.private.key.secret"
	}
	private let keychain = Keychain(service: StoreKeys.keychainService)

	func fetchAPIKeys() -> KeychainAccessActionResult<KeychainAccessAPIKeys> {
		do {
			let privateKey = try keychain.getString(StoreKeys.privateKeySecret)
			let publicKey = try keychain.getString(StoreKeys.publicKeySecret)
			guard let unwrapedPrivateKey = privateKey,
				  let unwrappedPublicKey = publicKey else {
				return .error(KeychainAccessError.error(for: .fetchingKeys))
			}

			return .success(.init(publicKey: unwrappedPublicKey, privateKey: unwrapedPrivateKey))
		} catch {
			return .error(KeychainAccessError.error(for: .fetchingKeys))
		}
	}

	func setProperty(for type: KeychainAccessSetterType, resultHandler: @escaping KeychainAccessSetterResultHandler) {
		do {
			switch type {
				case .privateKey(let privateKey):
					try keychain.set(privateKey, key: StoreKeys.privateKeySecret)
				case .publicKey(let publicKey):
					try keychain.set(publicKey, key: StoreKeys.publicKeySecret)
			}
			resultHandler(.success(()))
		} catch let error {
			print(error.localizedDescription)
			resultHandler(.error(KeychainAccessError.error(for: .settingProperty(type))))
		}
	}
}
