//
//  Set+Map.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 20.03.23.
//

import Foundation

extension Set {
    func setMap<U>(_ transform: (Element) -> U) -> Set<U> {
        return Set<U>(self.lazy.map(transform))
    }
}
