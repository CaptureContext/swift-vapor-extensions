# Swift Vapor Extensions

Experimental package, might be separated into multiple packages later, but semver is honored here.

## Contents

### FluentExtensions

Extends [vapor/fluent-kit](https://github.com/vapor/fluent-kit).

Features:

- `FieldKeyProvider`
  Protocol for `Model`s for better support or enum `FieldKey`s

- `AnyMigration`
  Protocol witness for `Migration` protocol. Allows you to create migrations inline.

- `MigrationGroup`
  Composition API for migrations, feel free to create your static factories in this type.

- `Migration.migration`
  Static factory for more convenient inline initialisation of your `Migration`s

- Exports `FluentKit`

### GraphitiExtensions

Extends [graphqlswift/graphiti](https://github.com/graphqlswift/graphiti).

Features:

- Typealeases with `GQL` prefix, so reserved type names like `Type` won't' confuse Xcode syntax highlighter and the code style will remain consistant since each GQL type has this prefix now

- `GQLType.reflecting` method with nested types support for initialising GQLType instances

- Exports `Graphiti`

### GraphQLKitExtensions

Extends [alexsteinerde/graphql-kit](https://github.com/alexsteinerde/graphql-kit).

Depends on:
- `develop` branch of [capturecontext/swift-prelude](https://github.com/capturecontext/swift-prelude).

- [GraphitiExtensions](#graphitiextensions)

Features:

- `GQLField` convenience initializers for `Vapor`

- `GraphQLJSONEncoder` conformance to `Vapor.ContentEncoder`

- `SimpleResolver` type for functional style of Resolver declarations

- Exports `GraphitiExtensions`

- Exports `GraphQLKit`

## License

This library is released under the MIT license. See [LICENSE](./LICENSE) for details.
