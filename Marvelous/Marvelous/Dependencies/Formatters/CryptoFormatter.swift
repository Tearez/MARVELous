//
//  DateFormatter.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 15.02.22.
//

import Foundation

protocol EpochDateFormatterProtocol {
	func formatDateTime(for epochTimeStamp: TimeInterval) -> String
}

protocol PriceFormatterProtocol {
	func formatPrice(_ price: Decimal) -> String
}

final class CryptoFormatter: EpochDateFormatterProtocol, PriceFormatterProtocol {
	private let dateFormatter = DateFormatter()
	private let priceFormatter = NumberFormatter()

	func formatDateTime(for epochTimeStamp: TimeInterval) -> String {
		let date = Date(timeIntervalSince1970: epochTimeStamp)
		dateFormatter.timeZone = .current
		dateFormatter.timeStyle = .short
		dateFormatter.dateStyle = .short
		return dateFormatter.string(from: date)
	}

	func formatPrice(_ price: Decimal) -> String {
		priceFormatter.locale = .current
		priceFormatter.numberStyle = .currency
		priceFormatter.usesGroupingSeparator = true
		priceFormatter.minimumFractionDigits = 0
		priceFormatter.maximumFractionDigits = 8
		return priceFormatter.string(from: price as NSDecimalNumber) ?? "\(price)"
	}
}
