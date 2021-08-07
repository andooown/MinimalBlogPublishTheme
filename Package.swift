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
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.8.0")
    ],
    targets: [
        .target(
            name: "MinimalBlogPublishTheme",
            dependencies: [
                "Publish"
            ]),
        .testTarget(
            name: "MinimalBlogPublishThemeTests",
            dependencies: ["MinimalBlogPublishTheme"]),
    ]
)
