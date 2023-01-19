//
//  LoadingTaskModifier.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 19.01.23.
//

import SwiftUI

struct LoadingTaskModifier: ViewModifier {
	@State private var shouldShowProgress: Bool = false
	private let action: () async -> Void

	init(action: @escaping () async -> Void) {
		self.action = action
	}


	func body(content: Content) -> some View {
		content
			.progressOverlay(shouldShowProgress)
			.task {
				shouldShowProgress = true
				await action()
				shouldShowProgress = false
			}
	}
}

extension View {
	func loadingTask(_ action: @escaping () async -> Void) -> some View {
		self
			.modifier(LoadingTaskModifier(action: action))
	}
}
