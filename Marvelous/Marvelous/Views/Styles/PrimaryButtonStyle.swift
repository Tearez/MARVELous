//
//  PrimaryButtonStyle.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration
			.label
			.font(.system(size: 16, weight: .bold))
			.foregroundColor(Colors.lightText.uiColor.color)
			.modifier(CardViewModifier(backgroundColor: Colors.primary.uiColor.color))
			.buttonStyle(ScaledButtonStyle())
	}
}

extension Button {
	func primaryButtonStyle() -> some View {
		self.buttonStyle(PrimaryButtonStyle())
	}
}
