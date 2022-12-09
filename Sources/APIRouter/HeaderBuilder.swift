import Foundation

public protocol HeaderProtocol {
  func build(_ header: inout Header)
}

@resultBuilder
public struct HeaderBuilder {
  public static func buildBlock(_ components: HeaderProtocol...) -> HeaderProtocol {
    CombinedHeader(components)
  }
  
  public static func buildArray(_ components: [HeaderProtocol]) -> HeaderProtocol {
    CombinedHeader(components)
  }
  
  public static func buildEither(first component: HeaderProtocol) -> HeaderProtocol {
    CombinedHeader([component])
  }
  
  public static func buildEither(second component: HeaderProtocol) -> HeaderProtocol {
    CombinedHeader([component])
  }
}

private struct CombinedHeader: HeaderProtocol {
  private let children: [HeaderProtocol]
  
  init(_ children: [HeaderProtocol]) {
    self.children = children
  }
  
  func build(_ header: inout Header) {
    children.forEach {
      $0.build(&header)
    }
  }
}

public extension Header {
  init(@HeaderBuilder _ fields: () -> HeaderProtocol) {
    let combineHeader = fields()
    var header = Header([:])
    combineHeader.build(&header)
    self = header
  }
}

struct Field: HeaderProtocol {
  private let value: String
  private let key: String
  
  public init(_ value: String, forKey key: String) {
    self.value = value
    self.key = key
  }
  
  public func build(_ header: inout Header) {
    var headers: [String: String] = [:]
    for item in header.headers {
      headers.updateValue(item.value, forKey: item.key)
    }
    headers.updateValue(value, forKey: key)
    header = Header(headers)
  }
}
