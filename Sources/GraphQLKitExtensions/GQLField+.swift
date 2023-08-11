import Fluent
import GraphitiExtensions
import Prelude
import Vapor

extension GQLField where Context == Request, Arguments == NoArguments {
  public convenience init<Resolver: SimpleResolver>(
    _ name: String,
    for keyPath: @escaping (ObjectType) -> Resolver
  ) where
    Resolver.Response == FieldType,
    Resolver.Arguments == Arguments
  {
    self.init(
      name,
      at: unpack <<< \.call <<< keyPath
    )
  }
}

extension GQLField where Context == Request, FieldType: Encodable {
  public convenience init<Resolver: SimpleResolver>(
    _ name: String,
    for keyPath: @escaping (ObjectType) -> Resolver,
    @ArgumentComponentBuilder<Arguments> _ arguments: () -> [ArgumentComponent<Arguments>]
  ) where
    Resolver.Response == FieldType,
    Resolver.Arguments == Arguments
  {
    self.init(
      name,
      at: unpack <<< \.call <<< keyPath,
      arguments
    )
  }
}

extension GQLField where Arguments == NoArguments {
  public convenience init(
    _ name: String,
    getter: @escaping (ObjectType) -> FieldType
  ) {
    let syncResolve: SyncResolve<
      ObjectType,
      Context,
      NoArguments,
      FieldType
    > = { object in
      { _, _ in getter(object) }
    }
    self.init(name, at: syncResolve, as: FieldType.self)
  }
}
