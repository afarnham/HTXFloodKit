// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HTXFloodKit",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "HTXFloodKit",
            targets: ["HTXFloodKit"]),
        .executable(name: "FloodServer", targets: ["FloodServer"]),
        .executable(name: "GaugeFetcher", targets: ["GaugeFetcher"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0")
        .package(url: "https://github.com/afarnham/HouFloodModel.git", .branch("master")),
        .package(url: "https://github.com/pointfreeco/swift-prelude.git", .branch("swift-5")),
		.package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.4.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/afarnham/swift-web.git", .branch("swift-5")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "HTXFloodKit",
            dependencies: [
                    "Prelude",
                    "Either", 
                    "Tagged", 
                    "Optics", 
                    "Logging",
                    "HouFloodModel"
            ]),
        .target(
            name: "FloodServer",
            dependencies: ["HTXFloodKit", "Css", "HttpPipeline", "ApplicativeRouter"]),
        .target(
        	name: "GaugeFetcher",
        	dependencies: ["HTXFloodKit"]),
        .testTarget(
            name: "HTXFloodKitTests",
            dependencies: ["HTXFloodKit"]),
    ]
)
