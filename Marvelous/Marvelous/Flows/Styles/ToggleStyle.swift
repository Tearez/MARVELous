//
//  ToggleStyle.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 19.01.23.
//

import SwiftUI

struct ListCarouselToggleStyle: ToggleStyle {

	func makeBody(configuration: Configuration) -> some View {
		HStack {
			Rectangle()
				.foregroundColor(color(isOn: configuration.isOn))
				.frame(width: 69, height: 31, alignment: .center)
				.overlay(
					RoundedRectangle(cornerRadius: 6)
						.foregroundColor(.white)
						.frame(width: 31)
						.padding(.all, 3)
						.overlay(
							Image(systemName: configuration.isOn ? "square.3.layers.3d.down.left" : "list.dash")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.font(Font.title.weight(.black))
								.frame(width: 16, height: 16, alignment: .center)
								.foregroundColor(color(isOn: configuration.isOn))
						)
						.offset(x: configuration.isOn ? 16 : -16, y: 0)
						.animation(.linear(duration: 0.1), value: configuration.isOn)

				).cornerRadius(8)
				.onTapGesture { configuration.isOn.toggle() }
		}
	}

	private func color(isOn: Bool) -> Color {
		if isOn {
			return Colors.primary.uiColor.color
		} else {
			return Colors.secondary.uiColor.color
		}
	}

}
