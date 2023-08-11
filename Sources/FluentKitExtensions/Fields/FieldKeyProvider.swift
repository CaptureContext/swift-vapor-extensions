import FluentKit

public protocol FieldKeyProvider where FieldKey.RawValue == String {
  associatedtype FieldKey: RawRepresentable
}

extension FieldKeyProvider {
  public static func fieldKey(_ key: Self.FieldKey) -> FluentKit.FieldKey { .string(key.rawValue) }
}
