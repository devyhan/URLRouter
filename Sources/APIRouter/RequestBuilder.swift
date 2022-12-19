import Foundation

/// [HttpMethod Reference](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods#:~:text=HTTP%20request%20methods,-HTTP%20defines%20a)
public enum HttpMethod: String {
  case options = "OPTIONS"
  case get     = "GET"
  case head    = "HEAD"
  case post    = "POST"
  case put     = "PUT"
  case patch   = "PATCH"
  case delete  = "DELETE"
  case trace   = "TRACE"
  case connect = "CONNECT"
}

public protocol RequestProtocol {
  func build(_ apiRequest: inout Request)
}

@resultBuilder
public struct RequestBuilder {
  public static func buildBlock(_ components: RequestProtocol...) -> RequestProtocol {
    CombinedRequest(components)
  }
}

private struct CombinedRequest: RequestProtocol {
  private let children: Array<RequestProtocol>
  
  init(_ children: Array<RequestProtocol>) {
    self.children = children
  }
  
  func build(_ apiRequest: inout Request) {
    children.forEach {
      $0.build(&apiRequest)
    }
  }
}

public extension Request {
  init(@RequestBuilder _ build: () -> RequestProtocol) {
    let combinedRequest = build()
    let url = Foundation.URL(string: "CANNOT_FIND_DEFAULT_URL")!
    var request = Request(URLRequest(url: url))
    combinedRequest.build(&request)
    self = request
  }
}

public struct Method: RequestProtocol {
  private let method: HttpMethod
  
  /// A parser of OPTIONS request method.
  public static let options = Self(.options)
  
  /// A parser of GET request method.
  public static let get = Self(.get)
  
  /// A parser of HEAD request method.
  public static let head = Self(.head)
  
  /// A parser of POST requests.
  public static let post = Self(.post)

  /// A parser of PUT requests.
  public static let put = Self(.put)

  /// A parser of PATCH requests.
  public static let patch = Self(.patch)

  /// A parser of DELETE requests.
  public static let delete = Self(.delete)
  
  /// A parser of TRACE requests.
  public static let trace = Self(.trace)
  
  /// A parser of CONNECT requests.
  public static let connect = Self(.connect)
  
  public init(_ method: HttpMethod) {
    self.method = method
  }
  
  public func build(_ apiRequest: inout Request) {
    apiRequest.urlRequest?.httpMethod = method.rawValue
  }
}

public struct Header: RequestProtocol {
  let headers: Dictionary<String, String>
  
  public init(_ headers: Dictionary<String, String>) {
    self.headers = headers
  }
  
  public func build(_ apiRequest: inout Request) {
    for header in headers {
      apiRequest.urlRequest?.addValue(header.value, forHTTPHeaderField: header.key)
    }
  }
}

public struct Body: RequestProtocol {
  let body: Dictionary<String, Any>
  
  public init(_ body: Dictionary<String, Any>) {
    self.body = body
  }
  
  public func build(_ apiRequest: inout Request) {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self.body, options: .fragmentsAllowed)
      apiRequest.urlRequest?.httpBody = jsonData
    } catch {
      print("Error \(error)")
    }
  }
}

public struct URL: RequestProtocol {
  var components: URLComponents
  
  public init(_ url: String) {
    self.components = URLComponents(string: url) ?? URLComponents()
  }
  
  public init(_ components: URLComponents) {
    self.components = components
  }
  
  public func build(_ apiRequest: inout Request) {
    apiRequest.urlRequest?.url = self.components.url
  }
}
