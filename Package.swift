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
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .branch("feature/spm-support")),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.2")
    ],
    targets: [
        .target(
            name: "TraktKit",
            dependencies: []),
        .testTarget(
            name: "TraktKitTests",
            dependencies: ["TraktKit", "OHHTTPStubsSwift", "Nimble"]),
    ]
)
