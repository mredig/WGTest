// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let url = "https://github.com/mredig/WGTest/releases/download/2025-07-10_22-07-09-00-00/WireGuardGoFoundation.xcframework.zip"
let checksum = "f32df2f0240bb912556247950cd61d49f62acf3e949150285cdfcacc39713770"

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
