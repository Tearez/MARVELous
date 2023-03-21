//
//  AlertButtonType.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 21.03.23.
//

import Foundation

enum AlertButtonType: Identifiable {
    case regular(String, (() -> Void)?)
    case cancel(String, (() -> Void)?)
    case destructive(String, (() -> Void)?)
    
    var id: Int {
        switch self {
        case .regular(let string, _):
            return string.hashValue
        case .cancel(let string, _):
            return string.hashValue
        case .destructive(let string, _):
            return string.hashValue
        }
    }
}
