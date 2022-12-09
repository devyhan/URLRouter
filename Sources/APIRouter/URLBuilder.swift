import Foundation

public enum URLScheme  {
  case http, https, mqtt, mqtts
  case custom(String)
  
  var rawValue: String {
    switch self {
    case .http:
      return "http"
    case .https:
      return "https"
    case .mqtt:
      return "mqtt"
    case .mqtts:
      return "mqtts"
    case let .custom(value):
      return value
    }
  }
}

public protocol HttpUrlProtocol {
  func build(_ url: inout URL)
}

@resultBuilder
public struct URLBuilder {
  public static func buildBlock(_ components: HttpUrlProtocol...) -> HttpUrlProtocol {
    CombinedURL(components)
  }
  
  public static func buildArray(_ components: [HttpUrlProtocol]) -> HttpUrlProtocol {
    CombinedURL(components)
  }
  
  static func buildEither(first component: HttpUrlProtocol) -> HttpUrlProtocol {
    CombinedURL([component])
  }
  
  static func buildEither(second component: HttpUrlProtocol) -> HttpUrlProtocol {
    CombinedURL([component])
  }
}

private struct CombinedURL: HttpUrlProtocol {
  private let children: [HttpUrlProtocol]
  
  init(_ children: [HttpUrlProtocol]) {
    self.children = children
  }
  
  func build(_ url: inout URL) {
    children.forEach {
      $0.build(&url)
    }
  }
}

public extension URL {
  init(@URLBuilder _ build: () -> HttpUrlProtocol) {
    let combineUrl = build()
    var url = URL(String())
    combineUrl.build(&url)
    self = url
  }
}

public struct Scheme: HttpUrlProtocol {
  private let scheme: URLScheme

  public init(_ scheme: URLScheme) {
    self.scheme = scheme
  }

  public func build(_ url: inout URL) {
    url.components.scheme = self.scheme.rawValue
  }
}

public struct Host: HttpUrlProtocol {
  private let host: String

  public init(_ host: String) {
    self.host = host
  }

  public func build(_ url: inout URL) {
    url.components.host = self.host
  }
}

public struct Path: HttpUrlProtocol {
  private let path: String

  public init(_ path: String) {
    self.path = path.prefix(1) != "/" ? "/" + path : path
  }

  public func build(_ url: inout URL) {
    url.components.path = self.path
  }
}

public struct Query: HttpUrlProtocol {
  private var queries: [URLQueryItem] = []
  
  public init(_ name: String, value: String?) {
    self.queries.append(URLQueryItem(name: name, value: value))
  }
  
  public init(_ queries: Dictionary<String, String?>) {
    for query in queries {
      self.queries.append(URLQueryItem(name: query.key, value: query.value))
    }
  }
  
  public func build(_ url: inout URL) {
    url.components.queryItems = self.queries
  }
}
