// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BEMCheckBox",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9)
    ],
    products: [
        .library(
            name: "BEMCheckBox",
            targets: ["BEMCheckBox"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BEMCheckBox",
            dependencies: [],
            path: ".",
            sources: ["Classes"],
            publicHeadersPath: "Classes"
        )
    ]
)
