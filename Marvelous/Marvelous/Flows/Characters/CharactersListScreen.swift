//
//  CharactersListScreen.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 11.01.23.
//

import SwiftUI

struct CharactersListScreen: View {
	@StateObject private var viewModel: CharactersListViewModel

	init() {
		self._viewModel = .init(wrappedValue: .init(dependency: DependencyContainer.shared))
	}

	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading) {
				ForEach(viewModel.models) { model in
					Text(model.name)
						.bold()
						.frame(maxWidth: .infinity)
						.modifier(CardViewModifier())
						.onAppear {
							viewModel.loadMoreContent(current: model)
						}
				}
			}
		}
		.task {
			await viewModel.getAll()
		}
	}
}

struct CharactersListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CharactersListScreen()
    }
}
