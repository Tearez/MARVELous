// swiftlint:disable all
import UIKit

// MARK: - Asset Catalogs

public enum Assets {
	public static let genericMarvelLogo = ImageAsset(name: "generic_marvel_logo")
}

public struct ImageAsset {
	fileprivate(set) var name: String

	public var image: UIImage {
		let bundle = BundleToken.bundle
		let image = UIImage(named: name, in: bundle, compatibleWith: nil)
		guard let result = image else {
			fatalError("Unable to load image asset named \(name).")
		}
		return result
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
