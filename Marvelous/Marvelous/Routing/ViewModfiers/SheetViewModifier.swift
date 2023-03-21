//
//  SheetViewModifier.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation
import SwiftUI

struct SheetViewModifier: ViewModifier {
    
    let option: SegueOption
    let screens: Binding<[AnyDestination]>
    let sheetDetents: Set<PresentationDetentTransformable>
    @Binding var sheetSelection: PresentationDetentTransformable
    let sheetSelectionEnabled: Bool
    let showDragIndicator: Bool
    
    func body(content: Content) -> some View {
        content
            .sheet(item: Binding(if: option,
                                 is: .sheet,
                                 value: Binding(toLastElementIn: screens)),
                   onDismiss: nil) { destination in
                if let view = screens.wrappedValue.last?.destination {
                    view
                        .presentationDetentsIfNeeded(
                            sheetDetents: sheetDetents,
                            sheetSelection: $sheetSelection,
                            sheetSelectionEnabled: sheetSelectionEnabled,
                            showDragIndicator: showDragIndicator)
                }
            }
    }
}

extension View {
    
    @ViewBuilder func presentationDetentsIfNeeded(
        sheetDetents: Set<PresentationDetentTransformable>,
        sheetSelection: Binding<PresentationDetentTransformable>,
        sheetSelectionEnabled: Bool,
        showDragIndicator: Bool) -> some View {
            if sheetSelectionEnabled {
                self
                    .presentationDetents(sheetDetents.setMap({ $0.asPresentationDetent }),
                                         selection: Binding(selection: sheetSelection))
                    .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
            } else {
                self
                    .presentationDetents(sheetDetents.setMap({ $0.asPresentationDetent }))
                    .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
            }
        }
}
