//
//  AsyncImageView.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 18.01.23.
//

import SwiftUI
import Kingfisher

struct AsyncImageView: View {
	private let url: URL?

	init(url: URL?) {
		self.url = url
	}

    var body: some View {
		KFImage(url)
			.placeholder {
				Image(uiImage: Assets.genericMarvelLogo.image)
					.resizable()
					.scaledToFit()
			}
			.cacheMemoryOnly()
			.memoryCacheExpiration(.seconds(180))
			.fade(duration: 0.25)
			.resizable()
			.scaledToFit()
    }
}

struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
		AsyncImageView(url: .init(string: ""))
    }
}
