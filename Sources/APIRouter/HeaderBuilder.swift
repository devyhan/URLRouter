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

public struct Field: HeaderProtocol, BodyProtocol, QueryProtocol {
  private let value: Any
  private let key: String
  
  public init(_ value: Any, forKey key: String) {
    self.value = value
    self.key = key
  }
  
  public func build(_ header: inout Header) {
    var headers: Dictionary<String, String> = [:]
    for item in header.headers {
      headers.updateValue(String(item.value), forKey: item.key)
    }
    if let value = value as? String {
      headers.updateValue(String(value), forKey: key)
    }
    header = Header(headers)
  }
  
  public func build(_ body: inout Body) {
    var dictionary: Dictionary<String, Any> = [:]
    for item in body.body {
      dictionary.updateValue(item.value, forKey: item.key)
    }
    dictionary.updateValue(value, forKey: key)
    body = Body(dictionary)
  }
  
  public func build(_ query: inout Query) {
    var queries: [URLQueryItem] = []
    for item in query.queries {
      queries.append(item)
    }
    if let value = value as? String {
      queries.append(URLQueryItem(name: key, value: value))
    }
    query = Query(queries)
  }
}
