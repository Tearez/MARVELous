//
//  SwiftUIView.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 5.07.22.
//

import SwiftUI

struct SwiftUIView: View {
	private let vm = VM()

    var body: some View {
		ZStack {
			Rectangle()
				.foregroundColor(Colors.secondary.uiColor.color)
				.ignoresSafeArea()
			SignInScreen()
		}
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
