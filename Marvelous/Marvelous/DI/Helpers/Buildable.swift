//
//  ViewModelable.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 7.02.23.
//

import Foundation

public protocol Buildable: AnyObject {}

open class Builder<DependencyType>: Buildable {
	let dependency: DependencyType

	init(dependency: DependencyType) {
		self.dependency = dependency
	}
}
