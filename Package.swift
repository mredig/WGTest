// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let url = "https://github.com/mredig/WGTest/releases/download//WireGuardGoFoundation.xcframework.zip"
let checksum = "947b9554f40eb4f08b0757698b5fe6c3b4c0718aee22dd2b225b70c7a59fdc03"

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
