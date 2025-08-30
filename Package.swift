// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RRUIComponents",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "RRUIComponents",
            targets: ["RRUIComponents"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/rirp53021/rr-swift-foundation.git", from: "1.7.3"),
        .package(url: "https://github.com/apple/swift-testing.git", from: "0.5.0")
    ],
    targets: [
        .target(
            name: "RRUIComponents",
            dependencies: [
                .product(name: "RRFoundation", package: "rr-swift-foundation")
            ],
            path: "Sources/RRUIComponents"
        ),
        .testTarget(
            name: "RRUIComponentsTests",
            dependencies: ["RRUIComponents", .product(name: "Testing", package: "swift-testing")],
            path: "Tests/RRUIComponentsTests"
        )
    ]
)

