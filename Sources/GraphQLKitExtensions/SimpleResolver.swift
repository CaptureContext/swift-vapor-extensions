import Fluent
import GraphitiExtensions
import Prelude
import Vapor

public protocol SimpleResolver: Function where
	Input == (Request, Arguments),
	Output == EventLoopFuture<Response>
{
	associatedtype Arguments: Decodable
	associatedtype Response: Encodable
}

extension SimpleResolver {
	public typealias CallSignature = ((Request, Arguments)) -> EventLoopFuture<Response>
}

extension SimpleResolver {
	public init(
		trowing call: @escaping ((Request, Arguments)) throws -> EventLoopFuture<Response>
	) {
		self.init({ request, arguments in
			do {
				return try call((request, arguments))
			} catch {
				return request.eventLoop.future(error: error)
			}
		})
	}
}
