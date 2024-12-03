// swift-tools-version: 5.9
import PackageDescription

/// WaterTracker: A hydration tracking application for macOS
///
/// This package defines the structure and dependencies for the WaterTracker app,
/// which helps users track their daily water intake and provides personalized
/// hydration recommendations based on various factors including weather and activity level.
let package = Package(
    name: "WaterTracker",
    
    // Minimum platform requirements
    platforms: [
        .macOS(.v14) // Updated to latest macOS version
    ],
    
    // Executable product definition
    products: [
        .executable(
            name: "WaterTracker",
            targets: ["WaterTracker"]
        )
    ],
    
    // External dependencies
    dependencies: [
        .package(
            url: "https://github.com/sindresorhus/Defaults.git",
            from: "7.3.1"
        )
    ],
    
    // Target definitions
    targets: [
        .executableTarget(
            name: "WaterTracker",
            dependencies: [
                "Defaults"
            ],
            path: "Sources/WaterTracker",
            exclude: ["Resources/Info.plist"],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ]
) 