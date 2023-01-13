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
					CharacterRowView(model: model)
						.onAppear {
							viewModel.loadMoreContent(current: model)
						}
				}
			}
		}
		.padding(.top, 16)
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
