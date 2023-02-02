// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RestService",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "RestService",
            targets: ["RestService"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
		.package(url: "https://github.com/Quick/Nimble", from: "11.2.1"),
		.package(url: "https://github.com/AliSoftware/OHHTTPStubs", from: "9.1.0"),
		.package(url: "https://github.com/Quick/Quick", from: "6.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RestService",
            dependencies: [],
			path: "Sources"),
        .testTarget(
            name: "RestServiceTests",
            dependencies: ["RestService", "Nimble", "OHHTTPStubs", "Quick"],
			path: "Tests"),
    ],
	swiftLanguageVersions: [.v5]
)
