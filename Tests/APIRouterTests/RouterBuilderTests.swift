import Foundation
import XCTest
@testable import APIRouter

final class RouterBuilderTests: XCTestCase {
  func testGeneratedRouterWithRouterBuilder() {
    let request = Router {
      Request {
        Body {
          Param("VALUE", forKey: "KEY")
        }
        Method(.get)
        Header {
          Field("HEADERVALUE", forKey: "HEADERKEY")
        }
        URL {
          Scheme(.https)
          Host("www.baseurl.com")
          Path("comments")
          Query("postId", value: "1")
        }
      }
    }
    
    var urlRequest = URLRequest(url: Foundation.URL(string: "https://www.baseurl.com/comments?postId=1")!)
    let bodyDictionary = ["KEY": "VALUE"]
    let body = try! JSONSerialization.data(withJSONObject: bodyDictionary, options: .fragmentsAllowed)
    let header = ["HEADERKEY": "HEADERVALUE"]
    urlRequest.httpBody = body
    urlRequest.httpMethod = "GET"
    urlRequest.allHTTPHeaderFields = header
    
    guard let request = request?.request.urlRequest else { return }
    
    XCTAssertEqual(request, urlRequest)
  }
  
  func testGeneratedRouterWithRouterBuilderUsingBaseURL() {
    let request = Router {
      BaseURL("https://www.baseurl.com")
      Request {
        Body {
          Param("VALUE", forKey: "KEY")
        }
        Method(.get)
        Header {
          Field("HEADERVALUE", forKey: "HEADERKEY")
        }
        URL {
          Path("comments")
          Query("postId", value: "1")
        }
      }
    }
    
    var urlRequest = URLRequest(url: Foundation.URL(string: "https://www.baseurl.com/comments?postId=1")!)
    let bodyDictionary = ["KEY": "VALUE"]
    let body = try! JSONSerialization.data(withJSONObject: bodyDictionary, options: .fragmentsAllowed)
    let header = ["HEADERKEY": "HEADERVALUE"]
    urlRequest.httpBody = body
    urlRequest.httpMethod = "GET"
    urlRequest.allHTTPHeaderFields = header
    
    guard let request = request?.request.urlRequest else { return }
    
    XCTAssertEqual(request, urlRequest)
  }
  
  func testRouterSwiftchBranching() {
    enum APIRouter {
      case one, two
      
      var router: Router? {
        Router {
          BaseURL("https://www.baseurl.com")
          switch self {
          case .one:
            Request {
              Body {
                Param("VALUE", forKey: "KEY")
              }
              Method(.get)
              Header {
                Field("HEADERVALUE", forKey: "HEADERKEY")
              }
              URL {
                Path("comments")
                Query("postId", value: "1")
              }
            }
          case .two:
            Request {
              Body {
                Param("VALUE", forKey: "KEY")
              }
              Method(.get)
              Header {
                Field("HEADERVALUE", forKey: "HEADERKEY")
              }
              URL {
                Path("comments")
                Query("postId", value: "2")
              }
            }
          }
        }
      }
    }
    
    let bodyDictionary = ["KEY": "VALUE"]
    let body = try! JSONSerialization.data(withJSONObject: bodyDictionary, options: .fragmentsAllowed)
    let header = ["HEADERKEY": "HEADERVALUE"]
    
    var optionOneUrlRequest = URLRequest(url: Foundation.URL(string: "https://www.baseurl.com/comments?postId=1")!)
    optionOneUrlRequest.httpBody = body
    optionOneUrlRequest.httpMethod = "GET"
    optionOneUrlRequest.allHTTPHeaderFields = header
    
    var optionTwoUrlRequest = URLRequest(url: Foundation.URL(string: "https://www.baseurl.com/comments?postId=2")!)
    optionTwoUrlRequest.httpBody = body
    optionTwoUrlRequest.httpMethod = "GET"
    optionTwoUrlRequest.allHTTPHeaderFields = header
    
    guard let optionOneRequest = APIRouter.one.router?.request.urlRequest else { return }
    guard let optionTwoRequest = APIRouter.two.router?.request.urlRequest else { return }
    
    XCTAssertEqual(optionOneRequest, optionOneUrlRequest)
    XCTAssertEqual(optionTwoRequest, optionTwoUrlRequest)
  }
}
