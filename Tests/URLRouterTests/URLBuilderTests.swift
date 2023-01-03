import Foundation
import XCTest
@testable import URLRouter

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
    let wsUrlRequest = Request {
      URL {
        Scheme(.ws)
      }
    }
    let wssUrlRequest = Request {
      URL {
        Scheme(.wss)
      }
    }
    let customUrlRequest = Request {
      URL {
        Scheme(.custom("custom"))
      }
    }
    
    if let httpUrlString = httpUrlRequest.urlRequest?.url?.absoluteString,
       let httpsUrlString = httpsUrlRequest.urlRequest?.url?.absoluteString,
       let mqttUrlString = mqttUrlRequest.urlRequest?.url?.absoluteString,
       let mqttsUrlString = mqttsUrlRequest.urlRequest?.url?.absoluteString,
       let wsUrlString = wsUrlRequest.urlRequest?.url?.absoluteString,
       let wssUrlString = wssUrlRequest.urlRequest?.url?.absoluteString,
       let customUrlString = customUrlRequest.urlRequest?.url?.absoluteString {
      XCTAssertEqual(httpUrlString, "http:")
      XCTAssertEqual(httpsUrlString, "https:")
      XCTAssertEqual(mqttUrlString, "mqtt:")
      XCTAssertEqual(mqttsUrlString, "mqtts:")
      XCTAssertEqual(wsUrlString, "ws:")
      XCTAssertEqual(wssUrlString, "wss:")
      XCTAssertEqual(customUrlString, "custom:")
    }
  }
  
  func testGeneratedUrlSchemeWithStaticParameterAndFunctionOfUrlBuilder() {
    let httpUrlRequest = Request {
      URL {
        Scheme.http
      }
    }
    let httpsUrlRequest = Request {
      URL {
        Scheme.https
      }
    }
    let mqttUrlRequest = Request {
      URL {
        Scheme.mqtt
      }
    }
    let mqttsUrlRequest = Request {
      URL {
        Scheme.mqtts
      }
    }
    let customUrlRequest = Request {
      URL {
        Scheme.custom("custom")
      }
    }
    
    if let httpUrlString = httpUrlRequest.urlRequest?.url?.absoluteString,
       let httpsUrlString = httpsUrlRequest.urlRequest?.url?.absoluteString,
       let mqttUrlString = mqttUrlRequest.urlRequest?.url?.absoluteString,
       let mqttsUrlString = mqttsUrlRequest.urlRequest?.url?.absoluteString,
       let customUrlString = customUrlRequest.urlRequest?.url?.absoluteString {
      XCTAssertEqual(httpUrlString, "http:")
      XCTAssertEqual(httpsUrlString, "https:")
      XCTAssertEqual(mqttUrlString, "mqtt:")
      XCTAssertEqual(mqttsUrlString, "mqtts:")
      XCTAssertEqual(customUrlString, "custom:")
    }
  }
  
  func testGeneratedUrlHostWithURLBuilder() {
    let request = Request {
      URL {
        Host("host.com")
      }
    }
    
    if let urlString = request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(urlString, "//host.com")
    }
  }
  
  func testGeneratedUrlPathWithURLBuilder() {
    let request = Request {
      URL {
        Path("test/path")
      }
    }
    
    if let pathString = request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(pathString, "/test/path")
    }
  }
  
  func testRemovedPrefixSlashToUrlPath() {
    let request = Request {
      URL {
        Path("/test/path")
      }
    }
    
    if let pathString = request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(pathString, "/test/path")
    }
  }
  
  func testGeneratedUrlQueryWithURLBuilder() {
    let request = Request {
      URL {
        Query("test", value: "query")
      }
    }
    
    if let queryString = request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(queryString, "?test=query")
    }
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
    
    if let queryString = request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(queryString.first, "?")
      XCTAssertEqual(queryString.contains("first=firstQuery"), true)
      XCTAssertEqual(queryString.contains("second=secondQuery"), true)
      XCTAssertEqual(queryString.split(separator: "&").count, 2)
    }
  }
  
  func testGeneratedUrlWithURLBuilder() {
    let request = Request {
      URL {
        Scheme(.https)
        Host("www.urltest.com")
        Path("test/path")
        Query("test", value: "query")
      }
    }
    
    if let url = request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(url, "https://www.urltest.com/test/path?test=query")
    }
  }
  
  func testSwitchConditionalStatementWorkingForBuildEitherInUrlBuilder() {
    enum SchemeOptions {
      case https
      case http
      
      var request: Request {
        Request {
         URL {
           switch self {
           case .https:
             Scheme(.https)
           case .http:
             Scheme(.http)
           }
           Host("www.urltest.com")
         }
       }
      }
    }
    
    if let httpUrlString = SchemeOptions.http.request.urlRequest?.url?.absoluteString,
       let httpsUrlstring = SchemeOptions.https.request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(httpUrlString, "http://www.urltest.com")
      XCTAssertEqual(httpsUrlstring, "https://www.urltest.com")
    }
  }
  
  func testIfConditionalStatementWorkingForBuildEitherInUrlBuilder() {
    enum SchemeOptions {
      case https
      case http
      
      var request: Request {
        Request {
         URL {
           if self == .http {
             Scheme(.http)
           } else {
             Scheme(.https)
           }
           Host("www.urltest.com")
         }
       }
      }
    }
    
    if let httpUrlString = SchemeOptions.http.request.urlRequest?.url?.absoluteString,
       let httpsUrlString = SchemeOptions.https.request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(httpUrlString, "http://www.urltest.com")
      XCTAssertEqual(httpsUrlString, "https://www.urltest.com")
    }
  }
  
  func testForLoopStatementWorkingForBuildEitherInUrlBuilder() {
    let queries = [
      "query1": "value1",
      "query2": "value2",
      "query3": "value3",
      "query4": "value4",
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
    
    if let queryItems = request.urlComponents?.queryItems {
      XCTAssertEqual(queryItems.contains(URLQueryItem(name: "query1", value: "value1")), true)
      XCTAssertEqual(queryItems.contains(URLQueryItem(name: "query2", value: "value2")), true)
      XCTAssertEqual(queryItems.contains(URLQueryItem(name: "query3", value: "value3")), true)
      XCTAssertEqual(queryItems.contains(URLQueryItem(name: "query4", value: "value4")), true)
    }
  }
}
