import FluentKit

extension Migration where Self == AnyMigration {
  @inlinable
  public static func migration(
    name: String,
    prepare: @escaping (Database) -> EventLoopFuture<Void>,
    revert: @escaping (Database) -> EventLoopFuture<Void>
  ) -> AnyMigration {
    return AnyMigration(
      name: name,
      prepare: prepare,
      revert: revert
    )
  }

  @inlinable
  public static func migration<T: Model>(
    _ name: String,
    for modelType: T.Type,
    prepare: @escaping (SchemaBuilder) -> EventLoopFuture<Void>,
    revert: @escaping (SchemaBuilder) -> EventLoopFuture<Void>
  ) -> AnyMigration {
    return AnyMigration(
      name,
      for: T.self,
      prepare: prepare,
      revert: revert
    )
  }
}

// MARK: - Concurrency

extension Migration where Self == AnyMigration {
  @inlinable
  public static func migration(
    name: String,
    prepare: @escaping (Database) async throws -> Void,
    revert: @escaping (Database) async throws -> Void
  ) -> AnyMigration {
    return AnyMigration(
      name: name,
      prepare: prepare,
      revert: revert
    )
  }

  @inlinable
  public static func migration<T: Model>(
    _ name: String,
    for modelType: T.Type,
    prepare: @escaping (SchemaBuilder) async throws -> Void,
    revert: @escaping (SchemaBuilder) async throws -> Void
  ) -> AnyMigration {
    return AnyMigration(
      name,
      for: T.self,
      prepare: prepare,
      revert: revert
    )
  }
}
