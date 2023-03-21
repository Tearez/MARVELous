//
//  FullScreenCoverModifier.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation
import SwiftUI

struct FullScreenCoverViewModifier: ViewModifier {
    
    let option: SegueOption
    let screens: Binding<[AnyDestination]>
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: Binding(if: option,
                                           is: .fullScreenCover,
                                           value: Binding(toLastElementIn: screens)),
                             onDismiss: nil) { _ in
                if let view = screens.wrappedValue.last?.destination {
                    view
                }
            }
    }
}
