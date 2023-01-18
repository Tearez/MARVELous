//
//  CharacterRowView.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 12.01.23.
//

import SwiftUI

struct CharacterRowView: View {
	private let model: CharactersListModel

	init(model: CharactersListModel) {
		self.model = model
	}

	var body: some View {
		HStack {
			AsyncImageView(url: model.thumbnailUrl)
				.frame(width: 50, height: 50)
				.cornerRadius(10)
			VStack(alignment: .leading) {
				Text(model.name)
					.font(.system(size: 20))
					.bold()
					.foregroundColor(Colors.lightText.uiColor.color)
				if let description = model.description {
					Text(description)
						.font(.system(size: 16))
						.lineLimit(3)
						.foregroundColor(Colors.lightText.uiColor.color)
				}
			}
			Spacer()
		}
		.frame(maxWidth: .infinity)
		.modifier(CardViewModifier(backgroundColor: Colors.primary.uiColor.color))
	}
}

struct CharacterRowView_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			CharacterRowView(model: .init(id: 1, name: "Hero", description: "Some hero", thumbnailUrl: nil))
			CharacterRowView(model: .init(id: 1, name: "Really long name Hero on two lines", description: "Some hero Some hero Some hero Some hero Some hero Some hero Some hero Some hero Some hero Some hero", thumbnailUrl: nil))
			CharacterRowView(model: .init(id: 1,
										  name: "Hero",
										  description: "Some hero Some hero Some hero Some hero Some hero Some hero Some hero Some hero Some hero Some hero",
										  thumbnailUrl: nil))

		}
    }
}
