import FluentKit
import ArrayBuilder

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
		@ArrayBuilder<MigrationGroup> _ groups: () -> [MigrationGroup]
	) -> MigrationGroup {
		return .group(groups())
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

	@inlinable
	public static func group(
		@ArrayBuilder<Migration> _ migrations: () -> [Migration]
	) -> MigrationGroup {
		return .group(migrations())
	}
}

// MARK: - Inline inits

extension MigrationGroup {
	@inlinable
	public static func migration(
		name: String,
		prepare: @escaping @Sendable (Database & Sendable) -> EventLoopFuture<Void>,
		revert: @escaping @Sendable (Database & Sendable) -> EventLoopFuture<Void>
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
		prepare: @escaping @Sendable (SchemaBuilder) -> EventLoopFuture<Void>,
		revert: @escaping @Sendable (SchemaBuilder) -> EventLoopFuture<Void>
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
		prepare: @escaping @Sendable (Database & Sendable) async throws -> Void,
		revert: @escaping @Sendable (Database & Sendable) async throws -> Void
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
		prepare: @escaping @Sendable (SchemaBuilder) async throws -> Void,
		revert: @escaping @Sendable (SchemaBuilder) async throws -> Void
	) -> MigrationGroup {
		return .init(.migration(
			name,
			for: T.self,
			prepare: prepare,
			revert: revert
		))
	}
}
