// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TraktKit",
    products: [
        .library(
            name: "TraktKit",
            targets: ["TraktKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "TraktKit",
            dependencies: []),
        .testTarget(
            name: "TraktKitTests",
            dependencies: ["TraktKit"]),
    ]
)
