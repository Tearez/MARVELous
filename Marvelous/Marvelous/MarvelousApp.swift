//
//  CryptoListApp.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 28.01.22.
//

import Combine
import SwiftUI

var storage: Set<AnyCancellable> = []

@main
struct MarvelousApp: App {
	private let viewModelFactory = ViewModelFactory()

    var body: some Scene {
        WindowGroup {
			EmptyView()
        }
    }
}
