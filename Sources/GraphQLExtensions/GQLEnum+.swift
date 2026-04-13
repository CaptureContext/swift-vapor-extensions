import ArrayBuilder
import Graphiti

extension Enum where EnumType: CaseIterable {
	public static func caseIterable(_ type: EnumType.Type = EnumType.self) -> Self {
		return .enumerate(type) {
			type.allCases.map { GQLValue($0) }
		}
	}
}

extension Enum {
	public static func enumerate(
		_ type: EnumType.Type = EnumType.self,
		@ArrayBuilder<GQLValue<EnumType>> values: () -> [GQLValue<EnumType>]
	) -> Self {
		return .init(type) { () -> [GQLValue<EnumType>] in
			return values()
		}
	}
}
