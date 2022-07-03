//
//  String+Localized.swift
//  CryptoList
//
//  Created by Martin Dimitrov on 1.02.22.
//

import Foundation

enum LocalizableTable: Int, RawRepresentable {
	case main

	var name: String {
		switch self {
			case .main:
				return "Localizable"
		}
	}
}

extension String {
	func localized(in table: LocalizableTable = .main,
				   bundle: Bundle = .main,
				   comment: String = "",
				   defaultValue: String = "") -> String {
		NSLocalizedString(self, tableName: table.name, bundle: bundle, value: defaultValue, comment: comment)
	}
}
