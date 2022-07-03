//
//  CardViewModifier.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 15.02.22.
//

import SwiftUI

struct CardViewModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(6)
			.background(Colors.background.uiColor.color)
			.cornerRadius(8)
			.shadow(color: .gray, radius: 4, x: 0, y: 0)
	}
}
