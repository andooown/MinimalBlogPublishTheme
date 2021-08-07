// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "MinimalBlogPublishTheme",
    products: [
        .library(
            name: "MinimalBlogPublishTheme",
            targets: ["MinimalBlogPublishTheme"]),
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0"),
        .package(url: "https://github.com/apple/swift-collections", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "MinimalBlogPublishTheme",
            dependencies: [
                "Publish",
                .product(name: "Collections", package: "swift-collections"),
            ]),
        .testTarget(
            name: "MinimalBlogPublishThemeTests",
            dependencies: ["MinimalBlogPublishTheme"]),
    ]
)
