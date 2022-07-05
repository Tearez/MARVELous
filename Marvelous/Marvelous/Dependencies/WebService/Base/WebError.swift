//
//  WebError.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 29.01.22.
//

import Foundation

struct WebError: Error, Decodable {
	let message: String
}
