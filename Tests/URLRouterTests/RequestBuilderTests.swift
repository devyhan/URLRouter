import Foundation
import XCTest
@testable import URLRouter

final class RequestBuilderTests: XCTestCase {
  func testGeneratedHttpRequestBodyWithBodyBuilder() {
    let request = Request {
      Body {
        Field("VALUE", forKey: "KEY")
      }
    }
    
    if let requestBody = request.urlRequest?.httpBody,
       let bodyString = String(data: requestBody, encoding: .utf8)
    {
      XCTAssertEqual(bodyString, "{\"KEY\":\"VALUE\"}")
    }
  }
  
  func testGeneratedHttpRequestBodyWithObjectThroughInitializer() {
    let request = Request {
      Body(["KEY": "VALUE"])
    }
    
    if let requestBody = request.urlRequest?.httpBody,
       let bodyString = String(data: requestBody, encoding: .utf8)
    {
      XCTAssertEqual(bodyString, "{\"KEY\":\"VALUE\"}")
    }
  }
  
  func testGeneratedHttpRequestHeaderWithHeaderBuilder() {
    let request = Request {
      Header {
        Field("JSON_VALUE", forKey: "JSON_KEY")
      }
    }
    
    if let requestHeader = request.urlRequest?.value(forHTTPHeaderField: "JSON_KEY") {
      XCTAssertEqual(requestHeader, "JSON_VALUE")
    }
  }
  
  func testGeneratedHttpRequestHeaderWithRequestBuilder() {
    let request = Request {
      Header(["KEY": "VALUE"])
    }
    
    if let requestHeader = request.urlRequest?.value(forHTTPHeaderField: "KEY") {
      XCTAssertEqual(requestHeader, "VALUE")
    }
  }
  
  func testGeneratedMethodProtocolWithRequestBuilder() {
    let optionsUrlRequest = Request {
      Method(.options)
    }
    let getUrlRequest = Request {
      Method(.get)
    }
    let headUrlRequest = Request {
      Method(.head)
    }
    let postUrlRequest = Request {
      Method(.post)
    }
    let putUrlRequest = Request {
      Method(.put)
    }
    let patchUrlRequest = Request {
      Method(.patch)
    }
    let deleteUrlRequest = Request {
      Method(.delete)
    }
    let traceUrlRequest = Request {
      Method(.trace)
    }
    let connectUrlRequest = Request {
      Method(.connect)
    }
    
    XCTAssertEqual(optionsUrlRequest.urlRequest?.httpMethod, "OPTIONS")
    XCTAssertEqual(getUrlRequest.urlRequest?.httpMethod, "GET")
    XCTAssertEqual(headUrlRequest.urlRequest?.httpMethod, "HEAD")
    XCTAssertEqual(postUrlRequest.urlRequest?.httpMethod, "POST")
    XCTAssertEqual(putUrlRequest.urlRequest?.httpMethod, "PUT")
    XCTAssertEqual(patchUrlRequest.urlRequest?.httpMethod, "PATCH")
    XCTAssertEqual(deleteUrlRequest.urlRequest?.httpMethod, "DELETE")
    XCTAssertEqual(traceUrlRequest.urlRequest?.httpMethod, "TRACE")
    XCTAssertEqual(connectUrlRequest.urlRequest?.httpMethod, "CONNECT")
  }
  
  func testGeneratedMethodProtocolWithStaticParameterOfRequestBuilder() {
    let optionsUrlRequest = Request {
      Method.options
    }
    let getUrlRequest = Request {
      Method.get
    }
    let headUrlRequest = Request {
      Method.head
    }
    let postUrlRequest = Request {
      Method.post
    }
    let putUrlRequest = Request {
      Method.put
    }
    let patchUrlRequest = Request {
      Method.patch
    }
    let deleteUrlRequest = Request {
      Method.delete
    }
    let traceUrlRequest = Request {
      Method.trace
    }
    let connectUrlRequest = Request {
      Method.connect
    }
    
    XCTAssertEqual(optionsUrlRequest.urlRequest?.httpMethod, "OPTIONS")
    XCTAssertEqual(getUrlRequest.urlRequest?.httpMethod, "GET")
    XCTAssertEqual(headUrlRequest.urlRequest?.httpMethod, "HEAD")
    XCTAssertEqual(postUrlRequest.urlRequest?.httpMethod, "POST")
    XCTAssertEqual(putUrlRequest.urlRequest?.httpMethod, "PUT")
    XCTAssertEqual(patchUrlRequest.urlRequest?.httpMethod, "PATCH")
    XCTAssertEqual(deleteUrlRequest.urlRequest?.httpMethod, "DELETE")
    XCTAssertEqual(traceUrlRequest.urlRequest?.httpMethod, "TRACE")
    XCTAssertEqual(connectUrlRequest.urlRequest?.httpMethod, "CONNECT")
  }
  
  func testGeneratedAssembleURLRequestWithRequestBuilder() {
    let request = Request {
      Body(["KEY": "VALUE"])
      Header {
        Field("HEADERVALUE", forKey: "HEADERKEY")
      }
      Method(.get)
      URL("https://www.urltest.com/test/path?first=query&second=query")
    }
    
    var urlRequest = URLRequest(url: Foundation.URL(string: "https://www.urltest.com/test/path?first=query&second=query")!)
    let bodyDictionary = ["KEY": "VALUE"]
    let body = try! JSONSerialization.data(withJSONObject: bodyDictionary, options: .fragmentsAllowed)
    let header = ["HEADERKEY": "HEADERVALUE"]
    urlRequest.httpBody = body
    urlRequest.httpMethod = "GET"
    urlRequest.allHTTPHeaderFields = header
    
    if let request = request.urlRequest {
      XCTAssertEqual(request, urlRequest)
    }
  }
}
