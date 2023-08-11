import FluentKit

public struct AnyMigration: Migration {
  public var name: String
  private var prepare: (Database) -> EventLoopFuture<Void>
  private var revert: (Database) -> EventLoopFuture<Void>

  public init(
    name: String,
    prepare: @escaping (Database) -> EventLoopFuture<Void>,
    revert: @escaping (Database) -> EventLoopFuture<Void>
  ) {
    self.name = name
    self.prepare = prepare
    self.revert = revert
  }

  public func prepare(on database: Database) -> EventLoopFuture<Void> { prepare(database) }
  public func revert(on database: Database) -> EventLoopFuture<Void> { revert(database) }
}

// MARK: - Convenience

extension AnyMigration {
  @inlinable
  public init(_ migration: Migration) {
    self.init(
      name: migration.name,
      prepare: migration.prepare,
      revert: migration.revert
    )
  }

  @inlinable
  public init<T: Model>(
    _ name: String,
    for modelType: T.Type,
    prepare: @escaping (SchemaBuilder) -> EventLoopFuture<Void>,
    revert: @escaping (SchemaBuilder) -> EventLoopFuture<Void>
  ) {
    self.init(
      name: name,
      prepare: { db in prepare(db.schema(modelType.schema)) },
      revert: { db in revert(db.schema(modelType.schema)) }
    )
  }
}

// MARK: Concurrency

extension AnyMigration {
  @inlinable
  public init(
    name: String,
    prepare: @escaping (Database) async throws -> Void,
    revert: @escaping (Database) async throws -> Void
  ) {
    self.init(
      name: name,
      prepare: { db in
        db.eventLoop.makeFutureWithTask {
          try await prepare(db)
        }
      },
      revert: { db in
        db.eventLoop.makeFutureWithTask {
          try await revert(db)
        }
      }
    )
  }

  @inlinable
  public init<T: Model>(
    _ name: String,
    for modelType: T.Type,
    prepare: @escaping (SchemaBuilder) async throws -> Void,
    revert: @escaping (SchemaBuilder) async throws -> Void
  ) {
    self.init(
      name: name,
      prepare: { db in
        db.eventLoop.makeFutureWithTask {
          try await prepare(db.schema(modelType.schema))
        }
      },
      revert: { db in
        db.eventLoop.makeFutureWithTask {
          try await revert(db.schema(modelType.schema))
        }
      }
    )
  }
}
