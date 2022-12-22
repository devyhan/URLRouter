import Foundation
import XCTest
@testable import URLRouter

final class RouterBuilderTests: XCTestCase {
  func testGeneratedRouterWithRouterBuilder() {
    let router = URLRouter {
      Request {
        Body {
          Field("VALUE", forKey: "KEY")
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
    
    var mcokUrlRequest = URLRequest(url: Foundation.URL(string: "https://www.baseurl.com/comments?postId=1")!)
    let bodyDictionary = ["KEY": "VALUE"]
    let body = try! JSONSerialization.data(withJSONObject: bodyDictionary, options: .fragmentsAllowed)
    let header = ["HEADERKEY": "HEADERVALUE"]
    mcokUrlRequest.httpBody = body
    mcokUrlRequest.httpMethod = "GET"
    mcokUrlRequest.allHTTPHeaderFields = header
    
    if let urlRequest = router.urlRequest {
      XCTAssertEqual(urlRequest, mcokUrlRequest)
    }
  }
  
  func testGeneratedRouterWithRouterBuilderUsingBaseURL() {
    let router = URLRouter {
      BaseURL("https://www.baseurl.com")
      Request {
        Body {
          Field("VALUE", forKey: "KEY")
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
    
    var mockUrlRequest = URLRequest(url: Foundation.URL(string: "https://www.baseurl.com/comments?postId=1")!)
    let bodyDictionary = ["KEY": "VALUE"]
    let body = try! JSONSerialization.data(withJSONObject: bodyDictionary, options: .fragmentsAllowed)
    let header = ["HEADERKEY": "HEADERVALUE"]
    mockUrlRequest.httpBody = body
    mockUrlRequest.httpMethod = "GET"
    mockUrlRequest.allHTTPHeaderFields = header
    
    if let urlRequest = router.urlRequest {
      XCTAssertEqual(urlRequest, mockUrlRequest)
    }
  }
  
  func testRouterSwiftchBranching() {
    enum URLs {
      case one, two, deeplink
      
      var router: URLRouter {
        URLRouter {
          BaseURL("https://www.baseurl.com")
          switch self {
          case .one:
            Request {
              Body {
                Field("VALUE", forKey: "KEY")
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
                Field("VALUE", forKey: "KEY")
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
          case .deeplink:
            URL {
              Scheme.custom("example-deeplink")
              Host("detail")
              Path("comments")
              Query {
                Field("postId", forKey: "1")
                Field("createdAt", forKey: "2021-04-27T04:39:54.261Z")
              }
            }
          }
        }
      }
    }
    
    let bodyDictionary = ["KEY": "VALUE"]
    let body = try! JSONSerialization.data(withJSONObject: bodyDictionary, options: .fragmentsAllowed)
    let header = ["HEADERKEY": "HEADERVALUE"]
    
    var mockOptionOneUrlRequest = URLRequest(url: Foundation.URL(string: "https://www.baseurl.com/comments?postId=1")!)
    mockOptionOneUrlRequest.httpBody = body
    mockOptionOneUrlRequest.httpMethod = "GET"
    mockOptionOneUrlRequest.allHTTPHeaderFields = header
    
    var mockOptionTwoUrlRequest = URLRequest(url: Foundation.URL(string: "https://www.baseurl.com/comments?postId=2")!)
    mockOptionTwoUrlRequest.httpBody = body
    mockOptionTwoUrlRequest.httpMethod = "GET"
    mockOptionTwoUrlRequest.allHTTPHeaderFields = header
    
    let mockDeeplinkUrl = Foundation.URL(string: "example-deeplink://detail/comments?1=postId&2021-04-27T04:39:54.261Z=createdAt")!
    
    if let optionOneUrlRequest = URLs.one.router.urlRequest,
       let optionTwoUrlRequest = URLs.two.router.urlRequest,
       let deeplinkUrl = URLs.deeplink.router.url {
      XCTAssertEqual(optionOneUrlRequest, mockOptionOneUrlRequest)
      XCTAssertEqual(optionTwoUrlRequest, mockOptionTwoUrlRequest)
      XCTAssertEqual(deeplinkUrl, mockDeeplinkUrl)
    }
  }
}