import FunctionComposition
import Vapor

public protocol SimpleAsyncResolver<Arguments, Response>: Sendable {
	associatedtype Arguments: Decodable & Sendable
	associatedtype Response: Encodable & Sendable
	typealias CallSignature = @Sendable ((Request, Arguments)) async throws -> Response
	var call: CallSignature { get }
	init(_ call: @escaping CallSignature)
}
