// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ZcashLightClientKit",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "ZcashLightClientKit",
            targets: ["ZcashLightClientKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/grpc/grpc-swift.git", revision: "9e464a75079928366aa7041769a271fac89271bf"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", revision: "9af51e2edf491c0ea632e369a6566e09b65aa333"),
        .package(name:"libzcashlc", url: "https://github.com/zcash-hackworks/zcash-light-client-ffi.git", revision: "b7e8a2abab84c44046b4afe4ee4522a0fa2fcc7f"),
    ],
    targets: [
        .target(
            name: "ZcashLightClientKit",
            dependencies: [
                .product(name: "SQLite", package: "SQLite.swift"),
                .product(name: "GRPC", package: "grpc-swift"),
                .product(name: "libzcashlc", package: "libzcashlc"),
            ],
            exclude: [
                "Service/ProtoBuf/proto/compact_formats.proto",
                "Service/ProtoBuf/proto/service.proto"
            ],
            resources: [
                .copy("Resources/saplingtree-checkpoints")
            ]
        ),
        .target(
            name: "TestUtils",
            dependencies: ["ZcashLightClientKit"],
            path: "Tests/TestUtils",
            exclude: [
                "proto/darkside.proto"
            ],
            resources: [
                .copy("test_data.db"),
                .copy("cache.db"),
                .copy("ZcashSdk_Data.db"),
            ]
        ),
        .testTarget(
            name: "OfflineTests",
            dependencies: ["ZcashLightClientKit", "TestUtils"]
        ),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["ZcashLightClientKit", "TestUtils"]
        ),
        .testTarget(
            name: "DarksideTests",
            dependencies: ["ZcashLightClientKit", "TestUtils"]
        )
    ]
)
