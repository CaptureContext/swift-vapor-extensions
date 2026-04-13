@preconcurrency import FluentKit

public struct AnyMigration: AsyncMigration {
	public var name: String
	private var prepare: @Sendable (Database) async throws -> Void
	private var revert: @Sendable (Database) async throws -> Void

	public init(
		name: String,
		prepare: @escaping @Sendable (Database) async throws -> Void,
		revert: @escaping @Sendable (Database) async throws -> Void
	) {
		self.name = name
		self.prepare = prepare
		self.revert = revert
	}
	
	public func prepare(
		on database: Database
	) async throws {
		try await prepare(database)
	}
	public func revert(
		on database: Database
	) async throws {
		try await revert(database)
	}
}

// MARK: - Convenience

extension AnyMigration {
	@inlinable
	public init(_ migration: Migration) {
		if let migration = migration as? AsyncMigration {
			self.init(
				name: migration.name,
				prepare: migration.prepare,
				revert: migration.revert
			)
		} else {
			self.init(
				name: migration.name,
				prepare: migration.prepare,
				revert: migration.revert
			)
		}
	}
	
	@inlinable
	public init<T: Model>(
		_ name: String,
		for modelType: T.Type,
		prepare: @escaping @Sendable (SchemaBuilder) -> EventLoopFuture<Void>,
		revert: @escaping @Sendable (SchemaBuilder) -> EventLoopFuture<Void>
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
		prepare: @escaping @Sendable (Database) -> EventLoopFuture<Void>,
		revert: @escaping @Sendable (Database) -> EventLoopFuture<Void>
	) {
		self.init(
			name: name,
			prepare: { db in
				try await prepare(db).get()
			},
			revert: { db in
				try await revert(db).get()
			}
		)
	}
	
	@inlinable
	public init<T: Model>(
		_ name: String,
		for modelType: T.Type,
		prepare: @escaping @Sendable (SchemaBuilder) async throws -> Void,
		revert: @escaping @Sendable (SchemaBuilder) async throws -> Void
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
