import GraphQLKit
import Vapor

extension GraphQLJSONEncoder: ContentEncoder {
  public func encode<E>(
    _ encodable: E,
    to body: inout ByteBuffer,
    headers: inout HTTPHeaders
  ) throws where E: Encodable {
    headers.contentType = .json
    try body.writeBytes(self.encode(encodable))
  }
}
