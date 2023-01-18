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
		list
		.task {
			await viewModel.getAll()
		}
	}

	private var list: some View {
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
	}

	private var carousel: some View {
		ScrollView(.init(), showsIndicators: false) {
			GeometryReader { proxy in
				let screen = proxy.frame(in: .global)
				if !viewModel.models.isEmpty {

					TabView {
						Group {
							ForEach(viewModel.models) { model in
								CharacterCarouselView(model: model)
									.onAppear {
										viewModel.loadMoreContent(current: model)
									}
							}
						}
						.frame(width: screen.width, height: screen.height)
					}
					.frame(width: proxy.size.width, height: proxy.size.height)
					.tabViewStyle(.page(indexDisplayMode: .never))

				} else {
					EmptyView()
				}
			}
		}
	}
}

struct CharactersListScreen_Previews: PreviewProvider {
    static var previews: some View {
        CharactersListScreen()
    }
}
