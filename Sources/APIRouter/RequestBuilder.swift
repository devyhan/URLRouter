import Foundation

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
