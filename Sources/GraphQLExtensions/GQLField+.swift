import _Tuples
import Vapor
import Graphiti

extension GQLField where Context == Request, Arguments == NoArguments {
	public convenience init<Resolver: SimpleAsyncResolver>(
		_ name: String,
		for keyPath: @escaping @Sendable (ObjectType) -> Resolver
	) where
		Resolver.Response == FieldType,
		Resolver.Arguments == Arguments
	{
		self.init(
			name,
			at: { unpack(sendable: keyPath($0).call) }
		)
	}
}

extension GQLField where Context == Request, FieldType: Encodable {
	public convenience init<Resolver: SimpleAsyncResolver>(
		_ name: String,
		for keyPath: @escaping @Sendable (ObjectType) -> Resolver,
		@ArgumentComponentBuilder<Arguments> _ arguments: () -> [ArgumentComponent<Arguments>]
	) where
		Resolver.Response == FieldType,
		Resolver.Arguments == Arguments
	{
		self.init(
			name,
			at: { unpack(sendable: keyPath($0).call) },
			arguments
		)
	}
}

extension GQLField where Arguments == NoArguments {
	public convenience init(
		_ name: String,
		getter: @escaping @Sendable (ObjectType) -> FieldType
	) {
		let resolve: AsyncResolve<
			ObjectType,
			Context,
			NoArguments,
			FieldType
		> = { object in
			{ _, _ in getter(object) }
		}

		self.init(
			name,
			at: resolve
		)
	}
}
