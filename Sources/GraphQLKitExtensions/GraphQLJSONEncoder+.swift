import GraphQLKit
import Vapor

extension GraphQLJSONEncoder: @retroactive ContentEncoder, @unchecked Sendable {
	public func encode<E>(
		_ encodable: E,
		to body: inout ByteBuffer,
		headers: inout HTTPHeaders
	) throws where E: Encodable {
		headers.contentType = .json
		try body.writeBytes(self.encode(encodable))
	}
}
