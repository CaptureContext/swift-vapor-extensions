import FluentKit

extension Fields {
  // For some reason `Field` typealias cannot be inferred,
  // so `_Field` typealias is declared as a workaround
  public typealias _Field<Value: Codable> = Field<Value>
}
