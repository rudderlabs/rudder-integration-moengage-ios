// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Rudder-Moengage",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(
            name: "Rudder-Moengage",
            targets: ["Rudder-Moengage"]
        )
    ],
    dependencies: [
        .package(name: "MoEngage-iOS-SDK", url: "https://github.com/moengage/MoEngage-iOS-SDK", .exact("9.18.0")),
        .package(name: "Rudder", url: "https://github.com/rudderlabs/rudder-sdk-ios", "1.12.0"..<"2.0.0"),
    ],
    targets: [
        .target(
            name: "Rudder-Moengage",
            dependencies: [
                .product(name: "MoEngage-iOS-SDK", package: "MoEngage-iOS-SDK"),
                .product(name: "Rudder", package: "Rudder"),
            ],
            path: "Rudder-Moengage",
            sources: ["Classes/"],
            publicHeadersPath: "Classes/",
            cSettings: [
                .headerSearchPath("Classes/")
            ]
        )
    ]
)
