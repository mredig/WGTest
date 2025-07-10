// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let url = "https://github.com/mredig/WGTest/releases/download/2025-07-10_21-25-37-00-00/WireGuardGoFoundation.xcframework.zip"
let checksum = "42d3474da4c80a364d4c168a497ad592bd5e9e75549289018fb9d0429a70a871"

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
