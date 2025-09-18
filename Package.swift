// swift-tools-version:5.3
import PackageDescription

let clibsodiumTarget: Target
#if os(OSX) || os(macOS) || os(tvOS) || os(watchOS) || os(iOS) || os(visionOS)
    clibsodiumTarget = .binaryTarget(
        name: "Clibsodium",
        path: "Clibsodium.xcframework")
#else
    clibsodiumTarget = .systemLibrary(
        name: "Clibsodium",
        path: "Clibsodium",
        pkgConfig: "libsodium",
        providers: [
            .apt(["libsodium-dev"]),
            .brew(["libsodium"]),
            // Waiting for bug to be fixed: https://bugs.swift.org/browse/SR-14038
            // .yum(["libsodium-devel"])
        ])
#endif

let package = Package(
    name: "Sodium",
    products: [
        .library(
            name: "Clibsodium",
            targets: ["Clibsodium"]),
        .library(
            name: "Sodium",
            targets: ["Sodium"]),
    ],
    targets: [
        clibsodiumTarget,
        .target(
            name: "Sodium",
            dependencies: ["Clibsodium"],
            path: "Sodium",
            exclude: ["libsodium", "Info.plist"]),
        .testTarget(
            name: "SodiumTests",
            dependencies: ["Sodium"],
            exclude: ["Info.plist"]),
    ]
)
