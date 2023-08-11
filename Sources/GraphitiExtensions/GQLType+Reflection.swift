import Graphiti

private struct Reflection {
  public static func name<Subject>(for instance: Subject) -> String {
    let reflectedTypeName = String(reflecting: instance)
      .components(separatedBy: ".")
      .dropFirst()
      .joined(separator: ".")

    var typeName: [Character] = []
    var genericArgument: [Character] = []
    var parsingTypeName = true

    for character in reflectedTypeName {
      guard character != " " else {
        break
      }

      if ["(", ")", "."].contains(character) {
        continue
      }

      if character == "<" {
        parsingTypeName = false
        continue
      }

      if character == ">" {
        parsingTypeName = true
        continue
      }

      if parsingTypeName {
        typeName.append(character)
      } else {
        genericArgument.append(character)
      }
    }

    return String(genericArgument + typeName)
  }
}

extension GQLType {
  /// Workaround for nested types support
  public static func reflecting(
    _ type: ObjectType.Type,
    interfaces: [Any.Type] = [],
    @FieldComponentBuilder<ObjectType, Context> _ fields: () -> [FieldComponent<ObjectType, Context>]
  ) -> GQLType<Resolver, Context, ObjectType> {
    return GQLType(
      type,
      as: Reflection.name(for: type),
      interfaces: interfaces,
      fields
    )
  }
}
