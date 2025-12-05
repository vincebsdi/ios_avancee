// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LearnTrack",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "LearnTrack",
            targets: ["LearnTrack"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "LearnTrack",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ]),
        .testTarget(
            name: "LearnTrackTests",
            dependencies: ["LearnTrack"]),
    ]
)
