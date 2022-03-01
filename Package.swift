// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "GZMatchedTransformEffect",
    platforms: [
        .iOS(.v14), .macOS(.v11), .watchOS(.v7)
    ],
    products: [
        .library(
            name: "GZMatchedTransformEffect",
            targets: ["GZMatchedTransformEffect"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GZMatchedTransformEffect",
            dependencies: []),
        .testTarget(
            name: "GZMatchedTransformEffectTests",
            dependencies: ["GZMatchedTransformEffect"]),
    ],
    swiftLanguageVersions: [.v5]
)
