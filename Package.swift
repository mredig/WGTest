// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let url = "https://github.com/mredig/WGTest/releases/download/2025-07-10_22-02-47-00-00/WireGuardGoFoundation.xcframework.zip"
let checksum = "955ae527cf005995095afea43eb4b3c7d6426ae9e732d6c31fc48b35f5cbe26a"

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
