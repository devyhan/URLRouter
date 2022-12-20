import Foundation

public protocol RouterProtocol {
  var router: Router? { get }
}

public protocol _RouterProtocol {
  func build(_ router: inout Router)
}

@resultBuilder
public struct RouterBuilder {
  public static func buildBlock(_ components: _RouterProtocol...) -> _RouterProtocol {
    CombinedRouter(components)
  }
  
  public static func buildArray(_ components: [_RouterProtocol]) -> _RouterProtocol {
    CombinedRouter(components)
  }
  
  public static func buildEither(first component: _RouterProtocol) -> _RouterProtocol {
    CombinedRouter([component])
  }
  
  public static func buildEither(second component: _RouterProtocol) -> _RouterProtocol {
    CombinedRouter([component])
  }
}

private struct CombinedRouter: _RouterProtocol {
  private let children: Array<_RouterProtocol>
  
  init(_ children: Array<_RouterProtocol>) {
    self.children = children
  }
  
  func build(_ router: inout Router) {
    children.forEach {
      $0.build(&router)
    }
  }
}
  
public extension Router {
  init?(@RouterBuilder _ build: @escaping () -> _RouterProtocol) {
    let CombinedRouter = build()
    var router = Router(Request(URLRequest(url: Foundation.URL(string: "CANNOT_FIND_BASE_URL")!)))
    CombinedRouter.build(&router)
    self = router
  }
}

public struct Router: _RouterProtocol {
  var request: Request
  public var urlRequest: URLRequest?
  public var urlComponents: URLComponents?
  
  public init(_ request: Request) {
    self.request = request
  }
  
  public func build(_ router: inout Router) {
    router.request = self.request
  }
}

public struct Request: _RouterProtocol {
  var urlRequest: URLRequest?
  var urlComponents: URLComponents?
  
  public init(_ urlRequest: URLRequest?) {
    self.urlRequest = urlRequest
  }
  
  public func build(_ router: inout Router) {
    if let url = buildUrl(&router) {
      router.request.urlRequest = URLRequest(url: url)
      router.request.urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    }
    
    router.request.urlRequest?.httpBody = self.urlRequest?.httpBody
    router.request.urlRequest?.httpMethod = self.urlRequest?.httpMethod
    router.request.urlRequest?.allHTTPHeaderFields = self.urlRequest?.allHTTPHeaderFields
    
    router.urlRequest = router.request.urlRequest
  }
  
  private func buildUrl(_ router: inout Router) -> Foundation.URL? {
    var url: Foundation.URL?
    if let defaultUrl = urlRequest?.url?.absoluteString {
      if defaultUrl != "CANNOT_FIND_DEFAULT_URL" {
        url = Foundation.URL(string: defaultUrl, relativeTo: router.request.urlRequest?.url)
      }
    }
    return url
  }
}

public struct BaseURL: _RouterProtocol {
  let url: String
  
  public init(_ url: String) {
    self.url = url
  }
  
  public func build(_ router: inout Router) {
    router.request = Request(URLRequest(url: Foundation.URL(string: self.url)!))
  }
}
