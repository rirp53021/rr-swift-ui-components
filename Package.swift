// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RRUIComponents",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "RRUIComponents",
            type: .dynamic,
            targets: ["RRUIComponents"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/rirp53021/rr-swift-foundation.git", from: "1.9.0")
    ],
    targets: [
        .target(
            name: "RRUIComponents",
            dependencies: [
                .product(name: "RRFoundation", package: "rr-swift-foundation")
            ],
            path: "Sources/RRUIComponents",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "RRUIComponentsTests",
            dependencies: ["RRUIComponents"],
            path: "Tests/RRUIComponentsTests"
        )
    ]
)
