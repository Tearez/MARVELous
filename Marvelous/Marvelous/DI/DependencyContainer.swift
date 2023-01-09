//
//  ViewModelFactory.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 30.01.22.
//

import Foundation
import Swinject

final class DependencyContainer {
	static let shared: DependencyContainer = .init()

	private let container: Container = .init()

	private init() {
		register()
	}

	private func register() {
		container.register(KeychainAccessSetterProtocol.self) { _ in
			KeychainAccess()
		}
	}
}

extension DependencyContainer: HasKeychainSetter {
	var keychainSetter: KeychainAccessSetterProtocol {
		container.resolve(KeychainAccessSetterProtocol.self)!
	}
}


