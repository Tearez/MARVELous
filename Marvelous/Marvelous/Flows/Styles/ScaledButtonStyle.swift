//
//  ScaledButtonStyle.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 1.02.22.
//

import SwiftUI

struct ScaledButtonStyle: ButtonStyle {
	private enum ScaledButtonStyleConstants {
		static let scalePressed: CGFloat = 0.97
		static let scaleDefault: CGFloat = 1
	}

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ?
						 ScaledButtonStyleConstants.scalePressed
						 : ScaledButtonStyleConstants.scaleDefault)
	}
}
