// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleFunctional",
    products: [
        .library(
            name: "SimpleFunctional",
            targets: ["SimpleFunctional"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "SimpleFunctional"),
    ]
)
