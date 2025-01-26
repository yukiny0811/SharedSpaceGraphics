// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SharedSpaceGraphics",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "SharedSpaceGraphics",
            targets: ["SharedSpaceGraphics"]
        ),
        .executable(
            name: "SharedSpaceGraphicsClient",
            targets: ["SharedSpaceGraphicsClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", exact: "600.0.1"),
        .package(url: "https://github.com/quassum/SwiftUI-Tooltip.git", branch: "main"),
    ],
    targets: [
        .macro(
            name: "SharedSpaceGraphicsMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "SharedSpaceGraphics",
            dependencies: [
                "SharedSpaceGraphicsMacros",
                .product(name: "SwiftUITooltip", package: "SwiftUI-Tooltip")
            ],
            resources: [
                .process("ShaderResources")
            ]
        ),
        .executableTarget(name: "SharedSpaceGraphicsClient", dependencies: ["SharedSpaceGraphics"]),
    ]
)
