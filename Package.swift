// swift-tools-version: 5.7.0

import PackageDescription

let package = Package(
    name: "APIRouter",
    platforms: [
      .iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "APIRouter",
            targets: ["APIRouter"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "APIRouter",
            dependencies: []),
        .testTarget(
            name: "APIRouterTests",
            dependencies: ["APIRouter"]),
    ]
)
