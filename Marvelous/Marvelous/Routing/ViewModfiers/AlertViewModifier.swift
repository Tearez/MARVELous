//
//  AlertViewModifier.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation
import SwiftUI

struct AlertViewModifier: ViewModifier {
    
    let option: AlertOption
    let item: Binding<AnyAlert?>
    
    func body(content: Content) -> some View {
        content
            .alert(item.wrappedValue?.title ?? "",
                   isPresented: Binding(
                    ifNotNil: Binding(if: option, is: .alert, value: item)
                   )
            ) {
                item.wrappedValue?.buttons
            } message: {
                if let subtitle = item.wrappedValue?.subtitle {
                    Text(subtitle)
                }
            }
    }
}
