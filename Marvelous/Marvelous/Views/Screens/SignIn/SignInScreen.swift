//
//  SignInScreen.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import SwiftUI

struct SignInScreen: View {
	@StateObject private var viewModel: SignInViewModel

	init() {
		self._viewModel = StateObject(wrappedValue: SignInViewModel(dependency: DependencyContainer.shared))
	}


	var body: some View {
		VStack(alignment: .center) {
			SecureField("sign_in_public_key".localized(), text: $viewModel.publicKey)
				.modifier(CardViewModifier(backgroundColor: Colors.background.uiColor.color))
			SecureField("sign_in_private_key".localized(), text: $viewModel.privateKey)
				.modifier(CardViewModifier(backgroundColor: Colors.background.uiColor.color))
			Button("sing_in__primary_button_title".localized(), action: {
				Task {
					await viewModel.signIn()
				}
			})
			.primaryButtonStyle()
		}
		.modifier(CardViewModifier(backgroundColor: Colors.background.uiColor.color))
		.alert("Error",
			   isPresented: .constant(viewModel.errorMessage != nil),
			   presenting: viewModel.errorMessage,
			   actions: { _ in
			Button("Close", action: {
				viewModel.errorMessage = nil
			})
		},
			   message: { message in
			Text(message)
		})
	}
}

struct SignInScreen_Previews: PreviewProvider {
	static var previews: some View {
		SignInScreen()
	}
}
