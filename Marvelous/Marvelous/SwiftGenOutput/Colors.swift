// swiftlint:disable all
import UIKit
import SwiftUI

public enum Colors {
	public static let background = ColorAsset(name: "background")
	public static let primary = ColorAsset(name: "primary")
}

public final class ColorAsset {
	fileprivate(set) var name: String

	public private(set) lazy var uiColor: UIColor = {
		guard let color = UIColor(asset: self) else {
			fatalError("Unable to load color asset named \(name).")
		}
		return color
	}()

	fileprivate init(name: String) {
		self.name = name
	}
}

public extension UIColor {
	var color: Color {
		Color(self)
	}
}

fileprivate extension UIColor {
	convenience init?(asset: ColorAsset) {
		let bundle = BundleToken.bundle
		self.init(named: asset.name, in: bundle, compatibleWith: nil)
	}
}

private final class BundleToken {
	static let bundle: Bundle = {
		#if SWIFT_PACKAGE
		return Bundle.module
		#else
		return Bundle(for: BundleToken.self)
		#endif
	}()
}
// swiftlint:enable all
