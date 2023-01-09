//
//  SecretHasher.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 22.07.22.
//

import CryptoKit
import Foundation

protocol SecretEncryptorProtocol {
	func encryptWebServiceHash(for privateKey: String, publicKey: String) -> String
}

final class SecretEncryptor: SecretEncryptorProtocol {
	func encryptWebServiceHash(for privateKey: String, publicKey: String) -> String {
		let timeStamp = Date().ISO8601Format()
		return Insecure.MD5.hash(data: (timeStamp + privateKey + publicKey).data(using: .utf8) ?? Data()).map { String(format: "%02hhx", $0) }.joined()
	}
}
