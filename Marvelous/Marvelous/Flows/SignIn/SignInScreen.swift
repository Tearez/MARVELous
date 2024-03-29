//
//  SignInScreen.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 9.01.23.
//

import SwiftUI

struct SignInScreen: View {
	@StateObject private var viewModel: SignInViewModel
	@State private var shouldShowProgress = false

	init(viewModel: SignInViewModel) {
		self._viewModel = StateObject(wrappedValue: viewModel)
	}


	var body: some View {
		ZStack {
			Colors.secondary.uiColor.color
				.ignoresSafeArea()
			VStack(alignment: .center) {
				SecureField("sign_in_public_key".localized(), text: $viewModel.publicKey)
					.modifier(CardViewModifier(backgroundColor: Colors.background.uiColor.color))
				SecureField("sign_in_private_key".localized(), text: $viewModel.privateKey)
					.modifier(CardViewModifier(backgroundColor: Colors.background.uiColor.color))
				Button("sing_in__primary_button_title".localized(), action: {
					Task {
						shouldShowProgress = true
						await viewModel.signIn()
						shouldShowProgress = false
						viewModel.didSignIn()
					}
				})
				.primaryButtonStyle()
			}
			.modifier(CardViewModifier(backgroundColor: Colors.background.uiColor.color))
			.alert("error_title".localized(),
				   isPresented: .constant(viewModel.errorMessage != nil),
				   presenting: viewModel.errorMessage,
				   actions: { _ in
				Button("close_action".localized(), action: {
					viewModel.resetError()
				})
			},
				   message: { message in
				Text(message)
			})
			.progressOverlay(shouldShowProgress)
			.loadingTask {
				await viewModel.checkKeychainStore()
			}
		}
	}
}
