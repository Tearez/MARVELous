//
//  VisualEffectViewRepresentable.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation
import SwiftUI

struct VisualEffectViewRepresentable: UIViewRepresentable {
    
    let effect: UIVisualEffect
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        view.effect = effect
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {}
}
