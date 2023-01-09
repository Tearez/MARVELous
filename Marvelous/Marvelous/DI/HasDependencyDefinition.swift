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
