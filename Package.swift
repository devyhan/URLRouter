// swift-tools-version: 5.7.0

import PackageDescription

let package = Package(
  name: "URLRouter",
  platforms: [
    .iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)
  ],
  products: [
    .library(
      name: "URLRouter",
      targets: ["URLRouter"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "URLRouter",
      dependencies: []),
    .testTarget(
      name: "URLRouterTests",
      dependencies: ["URLRouter"]),
  ]
)
