//
//  ConfirmationDialogViewModifier.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation
import SwiftUI

struct ConfirmationDialogViewModifier: ViewModifier {
    let option: AlertOption
    let item: Binding<AnyAlert?>
    
    func body(content: Content) -> some View {
        content
            .confirmationDialog(item.wrappedValue?.title ?? "",
                                isPresented: Binding(
                                    ifNotNil: Binding(if: option,
                                                      is: .confirmationDialog,
                                                      value: item)
                                ),
                                titleVisibility: item.wrappedValue?.title.isEmpty ?? true ? .hidden : .visible)
        {
            item.wrappedValue?.buttons
        } message: {
            if let subtitle = item.wrappedValue?.subtitle {
                Text(subtitle)
            }
        }
    }
    
}
