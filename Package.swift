// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "swift-vapor-extensions",
  platforms: [
      .macOS(.v10_15),
      .iOS(.v13),
      .watchOS(.v6),
      .tvOS(.v13),
  ],
  products: [
    .library(
      name: "FluentKitExtensions",
      targets: ["FluentKitExtensions"]
    ),
    .library(
      name: "GraphitiExtensions",
      targets: ["GraphitiExtensions"]
    ),
    .library(
      name: "GraphQLKitExtensions",
      targets: ["GraphQLKitExtensions"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/vapor/fluent-kit.git",
      .upToNextMajor(from: "1.44.0")
    ),
    .package(
      url: "https://github.com/graphqlswift/graphiti.git",
      .upToNextMinor(from: "0.26.0")
    ),
    .package(
      url: "https://github.com/alexsteinerde/graphql-kit.git",
      .upToNextMajor(from: "2.4.0")
    ),
    .package(
      url: "https://github.com/capturecontext/swift-prelude.git",
      branch: "develop"
    )
  ],
  targets: [
    .target(
      name: "FluentKitExtensions",
      dependencies: [
        .product(
          name: "FluentKit",
          package: "fluent-kit"
        )
      ]
    ),
    .target(
      name: "GraphitiExtensions",
      dependencies: [
        .product(
          name: "Graphiti",
          package: "graphiti"
        )
      ]
    ),
    .target(
      name: "GraphQLKitExtensions",
      dependencies: [
        .target(name: "GraphitiExtensions"),
        .product(
          name: "GraphQLKit",
          package: "graphql-kit"
        ),
        .product(
          name: "Prelude",
          package: "swift-prelude"
        )
      ]
    ),
  ]
)
