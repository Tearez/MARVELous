//
//  ProgressIndicatorModifier.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 10.01.23.
//

import SwiftUI

struct ProgressIndicatorModifier: ViewModifier {

	private var shouldShow: Bool

	init(shouldShow: Bool) {
		self.shouldShow = shouldShow
	}

	func body(content: Content) -> some View {
		content
			.overlay {
				ProgressView()
					.background(content: {
						Color.black
							.opacity(0.2)
							.frame(width: 75, height: 75)
							.cornerRadius(10)
					})
					.progressViewStyle(.circular)
					.opacity(shouldShow ? 1 : 0)
			}
	}
}

extension View {
	func progressOverlay(_ shouldShow: Bool) -> some View {
		self.modifier(ProgressIndicatorModifier(shouldShow: shouldShow))
	}
}
