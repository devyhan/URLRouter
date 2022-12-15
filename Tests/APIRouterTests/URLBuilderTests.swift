import Foundation
import XCTest
@testable import APIRouter

final class URLBuilderTests: XCTestCase {
  func testGeneratedUrlSchemeWithURLBuilder() {
    let httpUrlRequest = Request {
      URL {
        Scheme(.http)
      }
    }
    let httpsUrlRequest = Request {
      URL {
        Scheme(.https)
      }
    }
    let mqttUrlRequest = Request {
      URL {
        Scheme(.mqtt)
      }
    }
    let mqttsUrlRequest = Request {
      URL {
        Scheme(.mqtts)
      }
    }
    let customUrlRequest = Request {
      URL {
        Scheme(.custom("custom"))
      }
    }

    guard let httpUrlString = httpUrlRequest.urlRequest?.url?.absoluteString else { return }
    guard let httpsUrlString = httpsUrlRequest.urlRequest?.url?.absoluteString else { return }
    guard let mqttUrlString = mqttUrlRequest.urlRequest?.url?.absoluteString else { return }
    guard let mqttsUrlString = mqttsUrlRequest.urlRequest?.url?.absoluteString else { return }
    guard let customUrlString = customUrlRequest.urlRequest?.url?.absoluteString else { return }

    XCTAssertEqual(httpUrlString, "http:")
    XCTAssertEqual(httpsUrlString, "https:")
    XCTAssertEqual(mqttUrlString, "mqtt:")
    XCTAssertEqual(mqttsUrlString, "mqtts:")
    XCTAssertEqual(customUrlString, "custom:")
  }
  
  func testGeneratedUrlHostWithURLBuilder() {
    let request = Request {
      URL {
        Host("host.com")
      }
    }

    guard let urlString = request.urlRequest?.url?.absoluteString else { return }

    XCTAssertEqual(urlString, "//host.com")
  }
  
  func testGeneratedUrlPathWithURLBuilder() {
    let request = Request {
      URL {
        Path("test/path")
      }
    }

    guard let pathString = request.urlRequest?.url?.absoluteString else { return }

    XCTAssertEqual(pathString, "/test/path")
  }
  
  func testGeneratedUrlQueryWithURLBuilder() {
    let request = Request {
      URL {
        Query("test", value: "query")
      }
    }

    guard let queryString = request.urlRequest?.url?.absoluteString else { return }

    XCTAssertEqual(queryString, "?test=query")
  }
  
  func testGeneratedMultyUrlQueryWithURLBuilder() {
    let request = Request {
      URL {
        Query(
          [
            "first": "firstQuery",
            "second": "secondQuery"
          ]
        )
      }
    }

    guard let queryString = request.urlRequest?.url?.absoluteString else { return }

    XCTAssertEqual(queryString.first, "?")
    XCTAssertEqual(queryString.contains("first=firstQuery"), true)
    XCTAssertEqual(queryString.contains("second=secondQuery"), true)
    XCTAssertEqual(queryString.split(separator: "&").count, 2)
  }
  
  func testGeneratedURLWithURLBuilder() {
    let request = Request {
      URL {
        Scheme(.https)
        Host("www.urltest.com")
        Path("test/path")
        Query("test", value: "query")
      }
    }

    guard let url = request.urlRequest?.url?.absoluteString else { return }
    
    XCTAssertEqual(url, "https://www.urltest.com/test/path?test=query")
  }
  
  func testSwitchConditionalStatementWorkingForBuildEitherInUrlBuilder() {
    enum SchemeOptions {
      case https
      case http
    }
    
    let options: SchemeOptions = .http
    
    let request = Request {
      URL {
        switch options {
        case .https:
          Scheme(.https)
        case .http:
          Scheme(.http)
        }
        Host("www.urltest.com")
      }
    }
    
    guard let url = request.urlRequest?.url?.absoluteString else { return }
    
    XCTAssertEqual(url, "http://www.urltest.com")
  }
  
  func testIfConditionalStatementWorkingForBuildEitherInUrlBuilder() {
    let conditional = true
    
    let request = Request {
      URL {
        if conditional == true {
          Scheme(.http)
        } else {
          Scheme(.https)
        }
        Host("www.urltest.com")
      }
    }
    
    guard let url = request.urlRequest?.url?.absoluteString else { return }
    
    XCTAssertEqual(url, "http://www.urltest.com")
  }
  
  /// #1: https://github.com/devyhan/APIRouter/issues/1
  #warning("#1 change after issue resolution.")
  func testForLoopStatementWorkingForBuildEitherInUrlBuilder() {
    let queries = [
      "query1": "value1"//,
//      "query2": "value2",
//      "query3": "value3",
//      "query4": "value4",
    ]
    
    let request = Request {
      URL {
        Scheme(.https)
        Host("www.urltest.com")
        
        for query in queries {
          Query(query.key, value: query.value)
        }
      }
    }
    
    guard let url = request.urlRequest?.url?.absoluteString else { return }
    
    XCTAssertEqual(url, "https://www.urltest.com?query1=value1")
  }
}
