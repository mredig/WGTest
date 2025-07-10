// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let url = "https://github.com/mredig/WGTest/releases/download//WireGuardGoFoundation.xcframework.zip"
let checksum = "520172524ae0d42101d4d13b73ebac08bb7318f0ce9c17b29584a7ad8982df54"

let package = Package(
    name: "WireGuardKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
		.library(name: "WireGuardKit", targets: ["WireGuardKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WireGuardKit",
            dependencies: ["WireGuardGoFoundation", "WireGuardKitC"]
        ),
        .target(
            name: "WireGuardKitC",
            dependencies: [],
            publicHeadersPath: "."
        ),
		.binaryTarget(name: "WireGuardGoFoundation", url: url, checksum: checksum)
    ]
)
