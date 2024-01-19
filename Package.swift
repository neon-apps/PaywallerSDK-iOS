// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Paywaller",    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Paywaller",
            targets: ["Paywaller"])
    ],
    
    dependencies: [
        
        
        .package(url: "https://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@github.com/neon-apps/neon-sdk.git", branch: "main"),
      
       
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
       
        .target(
            name: "Paywaller",  dependencies: [
              "NeonSDK"
            ], path: "Paywaller", resources: [.process("Resources/Assets")])
        
    ]
)
