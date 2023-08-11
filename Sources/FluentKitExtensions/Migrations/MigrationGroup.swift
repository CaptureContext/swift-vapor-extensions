import FluentKit

extension Migrations {
  @inlinable
  public func add(_ group: MigrationGroup, to id: DatabaseID? = nil) {
    group.migrations.forEach { add($0, to: id) }
  }
}

public struct MigrationGroup {
  @inlinable
  public init(
    _ migrations: Migration...
  ) {
    self.init(migrations)
  }

  @inlinable
  public init(
    _ migrations: [Migration]
  ) {
    self.migrations = migrations
  }

  public let migrations: [Migration]
}

// MARK: - Composition

extension MigrationGroup {
  @inlinable
  public static func group(
    _ groups: MigrationGroup...
  ) -> MigrationGroup {
    return .group(groups)
  }

  @inlinable
  public static func group(
    _ groups: [MigrationGroup]
  ) -> MigrationGroup {
    return .group(groups.flatMap(\.migrations))
  }

  @inlinable
  public static func group(
    _ migrations: Migration...
  ) -> MigrationGroup {
    return .group(migrations)
  }

  @inlinable
  public static func group(
    _ migrations: [Migration]
  ) -> MigrationGroup {
    return MigrationGroup(migrations)
  }
}

// MARK: - Inline inits

extension MigrationGroup {
  @inlinable
  public static func migration(
    name: String,
    prepare: @escaping (Database) -> EventLoopFuture<Void>,
    revert: @escaping (Database) -> EventLoopFuture<Void>
  ) -> MigrationGroup {
    return .init(.migration(
      name: name,
      prepare: prepare,
      revert: revert
    ))
  }

  @inlinable
  public static func migration<T: Model>(
    _ name: String,
    for modelType: T.Type,
    prepare: @escaping (SchemaBuilder) -> EventLoopFuture<Void>,
    revert: @escaping (SchemaBuilder) -> EventLoopFuture<Void>
  ) -> MigrationGroup {
    return .init(.migration(
      name,
      for: T.self,
      prepare: prepare,
      revert: revert
    ))
  }
}

// MARK: Concurrency

extension MigrationGroup {
  @inlinable
  public static func migration(
    name: String,
    prepare: @escaping (Database) async throws -> Void,
    revert: @escaping (Database) async throws -> Void
  ) -> MigrationGroup {
    return .init(.migration(
      name: name,
      prepare: prepare,
      revert: revert
    ))
  }

  @inlinable
  public static func migration<T: Model>(
    _ name: String,
    for modelType: T.Type,
    prepare: @escaping (SchemaBuilder) async throws -> Void,
    revert: @escaping (SchemaBuilder) async throws -> Void
  ) -> MigrationGroup {
    return .init(.migration(
      name,
      for: T.self,
      prepare: prepare,
      revert: revert
    ))
  }
}
