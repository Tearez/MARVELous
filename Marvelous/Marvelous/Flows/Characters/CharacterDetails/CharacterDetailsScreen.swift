//
//  CharacterDetails.swift
//  Marvelous
//
//  Created by Martin Dimitrov on 19.01.23.
//

import SwiftUI

struct CharacterDetailsScreen: View {

	private let imageHeight: CGFloat = 300
	private let collapsedImageHeight: CGFloat = 75

	@ObservedObject private var articleContent: ViewFrame = ViewFrame()
	@State private var titleRect: CGRect = .zero
	@State private var headerImageRect: CGRect = .zero

	func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
		geometry.frame(in: .global).minY
	}

	func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
		let offset = getScrollOffset(geometry)
		let sizeOffScreen = imageHeight - collapsedImageHeight

		// if our offset is roughly less than -225 (the amount scrolled / amount off screen)
		if offset < -sizeOffScreen {
			// Since we want 75 px fixed on the screen we get our offset of -225 or anything less than. Take the abs value of
			let imageOffset = abs(min(-sizeOffScreen, offset))

			// Now we can the amount of offset above our size off screen. So if we've scrolled -250px our size offscreen is -225px we offset our image by an additional 25 px to put it back at the amount needed to remain offscreen/amount on screen.
			return imageOffset - sizeOffScreen
		}

		// Image was pulled down
		if offset > 0 {
			return -offset

		}

		return 0
	}

	func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
		let offset = getScrollOffset(geometry)
		let imageHeight = geometry.size.height

		if offset > 0 {
			return imageHeight + offset
		}

		return imageHeight
	}

	// at 0 offset our blur will be 0
	// at 300 offset our blur will be 6
	func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
		let offset = geometry.frame(in: .global).maxY

		let height = geometry.size.height
		let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)

		return blur * 6 // Values will range from 0 - 6
	}

	// 1
	private func getHeaderTitleOffset() -> CGFloat {
		let currentYPos = titleRect.midY

		// (x - min) / (max - min) -> Normalize our values between 0 and 1

		// If our Title has surpassed the bottom of our image at the top
		// Current Y POS will start at 75 in the beggining. We essentially only want to offset our 'Title' about 30px.
		if currentYPos < headerImageRect.maxY {
			let minYValue: CGFloat = 50.0 // What we consider our min for our scroll offset
			let maxYValue: CGFloat = collapsedImageHeight // What we start at for our scroll offset (75)
			let currentYValue = currentYPos

			let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue)) // Normalize our values from 75 - 50 to be between 0 to -1, If scrolled past that, just default to -1
			let finalOffset: CGFloat = -30.0 // We want our final offset to be -30 from the bottom of the image header view
			// We will start at 20 pixels from the bottom (under our sticky header)
			// At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
			// as x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px.

			return 20 - (percentage * finalOffset)
		}

		return .infinity
	}


	private let viewModel: CharacterDetailsViewModel

	init(viewModel: CharacterDetailsViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack {
				VStack(alignment: .leading, spacing: 10) {
					if let updated = viewModel.updated {
						Text(updated)
							.font(.system(size: 12))
							.foregroundColor(.gray)
					}

					if let name = viewModel.name {
						Text(name)
							.font(.system(size: 28, weight: .bold))
							.background(GeometryGetter(rect: self.$titleRect))
							.foregroundColor(Colors.darkText.uiColor.color) // 2
					}
					if let description = viewModel.description {
						Text(description)
							.lineLimit(nil)
							.font(.system(size: 17))
							.foregroundColor(Colors.darkText.uiColor.color)
					}
				}
				.padding(.horizontal)
				.padding(.top, 16.0)
			}
			.offset(y: imageHeight + 16)
			.background(GeometryGetter(rect: $articleContent.frame))

			GeometryReader { geometry in
				// 3
				ZStack(alignment: .bottom) {
					AsyncImageView(url: viewModel.thumbnailUrl)
						.scaledToFill()
						.frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry))
						.blur(radius: self.getBlurRadiusForImage(geometry))
						.clipped()
						.background(GeometryGetter(rect: self.$headerImageRect))

					// 4
					if let name = viewModel.name {
						Text(name)
							.font(.system(size: 17, weight: .bold))
							.foregroundColor(Colors.lightText.uiColor.color)
							.offset(x: 0, y: self.getHeaderTitleOffset())
					}
				}
				.clipped()
				.offset(x: 0, y: self.getOffsetForHeaderImage(geometry))
			}.frame(height: imageHeight)
				.offset(x: 0, y: -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
		}.edgesIgnoringSafeArea(.all)
	}
}

struct CharacterDetails_Previews: PreviewProvider {
	static var previews: some View {
		CharacterDetailsScreen(viewModel: .init(model: .init(id: 1,
															 name: "SuperHero",
															 description: """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nulla aliquet enim tortor at auctor urna nunc id cursus. Diam ut venenatis tellus in metus vulputate eu. Arcu vitae elementum curabitur vitae nunc sed. Pellentesque eu tincidunt tortor aliquam nulla facilisi cras. Sit amet risus nullam eget felis. Tempus egestas sed sed risus. Eu volutpat odio facilisis mauris sit amet massa vitae tortor. Eget sit amet tellus cras adipiscing. Dis parturient montes nascetur ridiculus mus mauris. Ipsum dolor sit amet consectetur adipiscing elit pellentesque habitant. Lobortis mattis aliquam faucibus purus. Fermentum iaculis eu non diam phasellus vestibulum lorem sed risus. Semper feugiat nibh sed pulvinar proin gravida. Vestibulum sed arcu non odio euismod.

Amet nisl purus in mollis nunc sed. Sed faucibus turpis in eu mi. Massa vitae tortor condimentum lacinia. Iaculis eu non diam phasellus vestibulum lorem. Iaculis eu non diam phasellus vestibulum lorem sed risus. Aliquet enim tortor at auctor urna nunc id cursus metus. Elementum nibh tellus molestie nunc. Id donec ultrices tincidunt arcu non sodales neque sodales. Scelerisque viverra mauris in aliquam sem. Fermentum iaculis eu non diam. Mattis molestie a iaculis at erat. Lacus laoreet non curabitur gravida arcu. Convallis convallis tellus id interdum velit laoreet id donec. Cursus vitae congue mauris rhoncus aenean vel elit.

Egestas pretium aenean pharetra magna ac placerat vestibulum. Nunc consequat interdum varius sit amet mattis vulputate. Scelerisque varius morbi enim nunc faucibus a pellentesque sit amet. Integer eget aliquet nibh praesent tristique magna sit. Non odio euismod lacinia at quis risus sed. Faucibus interdum posuere lorem ipsum dolor sit. Proin sagittis nisl rhoncus mattis rhoncus urna neque viverra justo. Sem nulla pharetra diam sit. Diam phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet. Volutpat lacus laoreet non curabitur gravida. At risus viverra adipiscing at in. Turpis in eu mi bibendum neque. Venenatis a condimentum vitae sapien pellentesque habitant.
""",
															 thumbnailUrl: nil,
															 updated: "12.12.2002",
															 comics: nil,
															 stories: nil,
															 series: nil,
															 events: nil)))
	}
}

class ViewFrame: ObservableObject {
	var startingRect: CGRect?

	@Published var frame: CGRect {
		willSet {
			if startingRect == nil {
				startingRect = newValue
			}
		}
	}

	init() {
		self.frame = .zero
	}
}

struct GeometryGetter: View {
	@Binding var rect: CGRect

	var body: some View {
		GeometryReader { geometry in
			AnyView(Color.clear)
				.preference(key: RectanglePreferenceKey.self, value: geometry.frame(in: .global))
		}.onPreferenceChange(RectanglePreferenceKey.self) { (value) in
			self.rect = value
		}
	}
}

struct RectanglePreferenceKey: PreferenceKey {
	static var defaultValue: CGRect = .zero

	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}
