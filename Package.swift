// swift-tools-version: 5.9
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
            targets: ["RRUIComponents"]
        ),
    ],
    dependencies: [
        // No external dependencies - all UI utilities are now self-contained
    ],
    targets: [
        .target(
            name: "RRUIComponents",
            dependencies: [],
            path: "Sources/RRUIComponents",
            resources: [
                .process("Info.plist")
            ]
        ),
        .testTarget(
            name: "RRUIComponentsTests",
            dependencies: ["RRUIComponents"],
            path: "Tests/RRUIComponentsTests"
        ),
    ]
)
