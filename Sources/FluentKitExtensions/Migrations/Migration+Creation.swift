import FluentKit

extension Migration where Self == AnyMigration {
	@inlinable
	public static func migration(
		name: String,
		prepare: @escaping @Sendable (Database & Sendable ) -> EventLoopFuture<Void>,
		revert: @escaping @Sendable (Database & Sendable) -> EventLoopFuture<Void>
	) -> AnyMigration {
		return AnyMigration(
			name: name,
			prepare: prepare,
			revert: revert
		)
	}
	
	@inlinable
	public static func migration<T: Model & Sendable>(
		_ name: String,
		for modelType: T.Type,
		prepare: @escaping @Sendable (SchemaBuilder) -> EventLoopFuture<Void>,
		revert: @escaping @Sendable (SchemaBuilder) -> EventLoopFuture<Void>
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
		prepare: @escaping @Sendable (Database & Sendable) async throws -> Void,
		revert: @escaping @Sendable (Database & Sendable) async throws -> Void
	) -> AnyMigration {
		return AnyMigration(
			name: name,
			prepare: prepare,
			revert: revert
		)
	}
	
	@inlinable
	public static func migration<T: Model & Sendable>(
		_ name: String,
		for modelType: T.Type,
		prepare: @escaping @Sendable (SchemaBuilder) async throws -> Void,
		revert: @escaping @Sendable (SchemaBuilder) async throws -> Void
	) -> AnyMigration {
		return AnyMigration(
			name,
			for: T.self,
			prepare: prepare,
			revert: revert
		)
	}
}
