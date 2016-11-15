update:
	@carthage update --platform iOS

cleanBuild:
	@xcodebuild -project incrementalSearch.xcodeproj  -sdk iphonesimulator -destination "platform=iOS Simulator,OS=10.0,name=iPhone 6s" clean build

ci:	update cleanBuild
