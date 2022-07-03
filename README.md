
# CryptoList-SwiftUI

## Build App

 1. Run `(sudo) gem install bundler`
	 - This is required because we use Cocoapods through **bundler** dependencies (**Gemfile**). This is done because the project was build using Cocoapods 1.11.2 this handles the case with different Cocoapods versions on different machines.
2. Navigate to root project directory and run `bundle install`
	- This will install all dependencies needed for the tools used by the project to run successfully
3. In the same directory run `bundle exec pod install (--repo-update)`
	- Basically runs `pod install` with the version described in **Gemfile**  

## SwiftGen
This project uses [SwiftGen](https://github.com/Swinject/Swinject) to generate type-safe Swift code for resources like images, colors, etc.  If you add a resource in either `../Resources/Colors.xcassets` or `../Resources/Images.xcassets` you will need to build the project once to regenerate the code for them and be able to use it.
