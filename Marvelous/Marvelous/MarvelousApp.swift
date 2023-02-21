//
//  CryptoListApp.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 28.01.22.
//

import SwiftUI

@main
struct MarvelousApp: App {
	private let dependendy: DependencyContainer = DependencyContainer()

    var body: some Scene {
        WindowGroup {
			RootRouter(builders: .init(
				signInBuildable: SignInBuilder(dependency: dependendy)
			),
					   interactor: dependendy.rootRouterInteractor)
		}
    }
}
