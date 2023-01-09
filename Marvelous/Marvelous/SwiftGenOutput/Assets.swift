// swiftlint:disable all
import UIKit

// MARK: - Asset Catalogs

public enum Assets {
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
