//
//  CardViewModifier.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 15.02.22.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
	struct CardViewModifierInsets {
		let horizontal: CGFloat?
		let vertical: CGFloat?

		init(horizontal: CGFloat? = nil, vertical: CGFloat? = nil) {
			self.horizontal = horizontal
			self.vertical = vertical
		}
	}

	private let backgroundColor: Color
	private let cornerRadius: Double
	private let insets: CardViewModifierInsets?

	init(backgroundColor: Color? = nil,
		 cornerRadius: Double? = nil,
		 insets: CardViewModifierInsets? = nil) {
		self.backgroundColor = backgroundColor ?? Colors.secondary.uiColor.color
		self.cornerRadius = cornerRadius ?? 8
		self.insets = insets
	}

	func body(content: Content) -> some View {
		ZStack {
			content
				.padding(.horizontal, insets?.horizontal)
				.padding(.vertical, insets?.vertical)
				.background(backgroundColor)
				.cornerRadius(cornerRadius)
				.shadow(color: .gray, radius: 4, x: 0, y: 0)
		}
		.padding(.all)
	}
}
