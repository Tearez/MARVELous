//
//  NavigationViewIfNeeded.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation
import SwiftUI

struct NavigationViewIfNeeded<Content:View>: View {
    
    let addNavigationView: Bool
    let segueOption: SegueOption
    @Binding var screens: [AnyDestination]
    @ViewBuilder var content: Content
    
    @ViewBuilder var body: some View {
        if addNavigationView {
            NavigationStackTransformable(segueOption: segueOption, screens: $screens) {
                content
            }
        } else {
            content
        }
    }
}

struct NavigationStackTransformable<Content:View>: View {
    
    // Convert [AnyDestination] to NavigationPath
    // Note: it works without the conversion, but there is a warning in console.
    // "Only root-level navigation destinations are effective for a navigation stack with a homogeneous path"
    
    let segueOption: SegueOption
    @Binding var screens: [AnyDestination]
    @ViewBuilder var content: Content

    @State private var path: NavigationPath = .init()
    @State private var isPushEnabled: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            content
        }
        .onAppear {
            isPushEnabled = segueOption == .push
        }
        .onChange(of: segueOption, perform: { newValue in
            isPushEnabled = newValue == .push
        })
        .onChange(of: screens) { newValue in
            if isPushEnabled {
                path = .init(newValue)
            }
        }
    }
    
}
