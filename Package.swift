// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "BEMCheckBox",
    platforms: [
       .iOS(.v9)
    ],
    products: [
        .library(name: "BEMCheckBox", targets: ["BEMCheckBox"])
    ],
    targets: [
        .target(name: "BEMCheckBox", dependencies: [], path: "Classes")
    ]
)
