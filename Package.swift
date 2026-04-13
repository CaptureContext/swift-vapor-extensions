// swift-tools-version: 6.1

import PackageDescription

let package = Package(
	name: "swift-vapor-extensions",
	platforms: [
		.macOS(.v13),
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
			name: "GraphQLExtensions",
			targets: ["GraphQLExtensions"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/vapor/fluent-kit.git",
			.upToNextMajor(from: "1.44.0")
		),
		.package(
			url: "https://github.com/graphqlswift/graphiti.git",
			.upToNextMajor(from: "3.1.0")
		),
		.package(
			url: "https://github.com/graphqlswift/graphql-vapor.git",
			.upToNextMajor(from: "1.0.0")
		),
		.package(
			url: "https://github.com/capturecontext/swift-keypaths-extensions.git",
			.upToNextMajor(from: "0.2.0")
		),
		.package(
			url: "https://github.com/capturecontext/swift-result-builders.git",
			.upToNextMajor(from: "0.0.2")
		),
		.package(
			url: "https://github.com/capturecontext/swift-function-composition.git",
			branch: "tuples"
		),
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
			name: "GraphQLExtensions",
			dependencies: [
				.product(
					name: "KeyPathsExtensions",
					package: "swift-keypaths-extensions"
				),
				.product(
					name: "Graphiti",
					package: "graphiti"
				),
				.product(
					name: "GraphQLVapor",
					package: "graphql-vapor"
				),
				.product(
					name: "_Tuples",
					package: "swift-function-composition"
				),
				.product(
					name: "ArrayBuilder",
					package: "swift-result-builders"
				),
			]
		),
	]
)
