// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BeerPackage",
    products: [
        .library(
            name: "BeerPackage",
            targets: ["BeerDomain", "BeerAPI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BeerDomain",
            dependencies: [],
            path: "Sources/Domain"),
        .target(
            name: "BeerAPI",
            dependencies: ["Helpers"],
            path: "Sources/API"),
        .target(
            name: "Helpers",
            dependencies: []),
        .target(
            name: "TestHelpers",
            dependencies: []),
        .testTarget(
            name: "APITests",
            dependencies: ["BeerDomain", "BeerAPI", "Helpers", "TestHelpers"]),
        .testTarget(
            name: "APIEndToEndTests",
            dependencies: ["BeerDomain", "BeerAPI", "Helpers", "TestHelpers"]),
    ]
)
