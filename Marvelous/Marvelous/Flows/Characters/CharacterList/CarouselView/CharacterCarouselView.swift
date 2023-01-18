//
//  CarouselView.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 18.01.23.
//

import SwiftUI
import Kingfisher

struct CharacterCarouselView: View {
	private let model: CharactersListModel

	init(model: CharactersListModel) {
		self.model = model
		print(model.name)
	}

    var body: some View {
		GeometryReader { proxy in
			VStack {
				AsyncImageView(url: model.thumbnailUrl)

				VStack(alignment: .leading, spacing: 8) {
					HStack {
						Text(model.name)
							.foregroundColor(Colors.lightText.uiColor.color)
							.font(.system(size: 36))
							.fontWeight(.heavy)
						Spacer()
					}
					if let description = model.description {
						Text(description)
							.foregroundColor(Colors.lightText.uiColor.color)
							.font(.system(size: 20))
							.fontWeight(.semibold)
							.lineLimit(10)
					}
				}
				.padding([.horizontal, .bottom])

			}
			.modifier(CardViewModifier(backgroundColor: Colors.primary.uiColor.color,
									   cornerRadius: 24,
									   insets: .init(horizontal: .zero, vertical: .zero)))
			.frame(width: proxy.size.width, height: proxy.size.height)
		}
    }
}

struct CharacterCarouselView_Previews: PreviewProvider {
    static var previews: some View {
		CharacterCarouselView(model: .init(id: 1, name: "SuperHero", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", thumbnailUrl: nil))
    }
}
