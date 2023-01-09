//
//  CardViewModifier.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 15.02.22.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
	private let backgroundColor: Color

	init(backgroundColor: Color? = nil) {
		self.backgroundColor = backgroundColor ?? Colors.secondary.uiColor.color
	}

	func body(content: Content) -> some View {
		ZStack {
			content
				.padding(.all)
				.background(backgroundColor)
				.cornerRadius(8)
				.shadow(color: .gray, radius: 4, x: 0, y: 0)
		}
		.padding(.horizontal)
	}
}
