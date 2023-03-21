//
//  AnyAlert.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation
import SwiftUI

struct AnyAlert: Identifiable {
    let id = UUID().uuidString
    let title: String
    let subtitle: String?
    let buttons: AnyView

    init<T:View>(title: String, subtitle: String? = nil, buttons: T) {
        self.title = title
        self.subtitle = subtitle
        self.buttons = AnyView(buttons)
    }
}
