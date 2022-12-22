import Foundation

public protocol URLRoutable {
  var router: URLRouter { get }
}

public protocol URLRouterProtocol {
  func build(_ router: inout URLRouter)
}

@resultBuilder
public struct RouterBuilder {
  public static func buildBlock(_ components: URLRouterProtocol...) -> URLRouterProtocol {
    CombinedRouter(components)
  }
  
  public static func buildArray(_ components: [URLRouterProtocol]) -> URLRouterProtocol {
    CombinedRouter(components)
  }
  
  public static func buildEither(first component: URLRouterProtocol) -> URLRouterProtocol {
    CombinedRouter([component])
  }
  
  public static func buildEither(second component: URLRouterProtocol) -> URLRouterProtocol {
    CombinedRouter([component])
  }
}

private struct CombinedRouter: URLRouterProtocol {
  private let children: Array<URLRouterProtocol>
  
  init(_ children: Array<URLRouterProtocol>) {
    self.children = children
  }
  
  func build(_ router: inout URLRouter) {
    children.forEach {
      $0.build(&router)
    }
  }
}
  
public extension URLRouter {
  init(@RouterBuilder _ build: @escaping () -> URLRouterProtocol) {
    let CombinedRouter = build()
    var router = URLRouter(Request(URLRequest(url: Foundation.URL(string: "CANNOT_FIND_BASE_URL")!)))
    CombinedRouter.build(&router)
    self = router
  }
}

public struct URLRouter: URLRouterProtocol {
  var request: Request
  public var url: Foundation.URL?
  public var urlRequest: URLRequest?
  public var urlComponents: URLComponents?
  
  public init(_ request: Request) {
    self.request = request
  }
  
  public func build(_ router: inout URLRouter) {
    router.request = self.request
  }
}

public struct Request: URLRouterProtocol {
  var urlRequest: URLRequest?
  var urlComponents: URLComponents?
  
  public init(_ urlRequest: URLRequest?) {
    self.urlRequest = urlRequest
  }
  
  public func build(_ router: inout URLRouter) {
    if let url = buildUrl(&router) {
      router.request.urlRequest = URLRequest(url: url)
      router.request.urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
    }
    
    router.request.urlRequest?.httpBody = self.urlRequest?.httpBody
    router.request.urlRequest?.httpMethod = self.urlRequest?.httpMethod
    router.request.urlRequest?.allHTTPHeaderFields = self.urlRequest?.allHTTPHeaderFields
    
    router.urlRequest = router.request.urlRequest
    router.urlComponents = router.request.urlComponents
  }
  
  private func buildUrl(_ router: inout URLRouter) -> Foundation.URL? {
    var url: Foundation.URL?
    if let urlRequestString = urlRequest?.url?.absoluteString,
       let urlComponentsString = urlComponents?.url?.absoluteString {
      if urlRequestString != "CANNOT_FIND_DEFAULT_URL" {
        let urlString = urlRequestString > urlComponentsString ? urlRequestString : urlComponentsString
        url = Foundation.URL(string: urlString, relativeTo: router.request.urlRequest?.url)
      }
    }
    return url
  }
}

public struct BaseURL: URLRouterProtocol {
  let url: String
  
  public init(_ url: String) {
    self.url = url
  }
  
  public func build(_ router: inout URLRouter) {
    router.request = Request(URLRequest(url: Foundation.URL(string: self.url)!))
  }
}
