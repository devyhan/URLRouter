import Foundation
import XCTest
@testable import URLRouter

final class QueryBUilderTests: XCTestCase {
  func testGeneratedMultyUrlQueryWithQueryBuilder() {
    let request = Request {
      URL {
        Query {
          Field("firstQuery", forKey: "first")
          Field("secondQuery", forKey: "second")
        }
      }
    }
    
    if let queryString = request.urlRequest?.url?.absoluteString {
      XCTAssertEqual(queryString.first, "?")
      XCTAssertEqual(queryString.contains("first=firstQuery"), true)
      XCTAssertEqual(queryString.contains("second=secondQuery"), true)
      XCTAssertEqual(queryString.split(separator: "&").count, 2)
    }
  }
  
  func testSwitchConditionStatementWorkingForBuildEitherInQueryBuilder() {
    enum QueryOptions {
      case one
      case two
      
      var request: Request {
        Request {
          URL {
            Query {
              switch self {
              case .one:
                Field("firstQuery", forKey: "first")
              case .two:
                Field("secondQuery", forKey: "second")
              }
            }
          }
        }
      }
    }
    
    if let optionOneQueryFields = QueryOptions.one.request.urlComponents?.queryItems,
       let optionTwoQueryFields = QueryOptions.two.request.urlComponents?.queryItems {
      XCTAssertEqual(optionOneQueryFields.first?.debugDescription, "first=firstQuery")
      XCTAssertEqual(optionTwoQueryFields.first?.debugDescription, "second=secondQuery")
    }
  }
  
  func testIfConditionalStatementWorkingForBuildEitherInQueryBuilder() {
    enum QueryOptions {
      case one
      case two
      
      var request: Request {
        Request {
          URL {
            Query {
              if self == .one {
                Field("firstQuery", forKey: "first")
              } else {
                Field("secondQuery", forKey: "second")
              }
            }
          }
        }
      }
    }
    
    if let optionOneQueryFields = QueryOptions.one.request.urlComponents?.queryItems,
       let optionTwoQueryFields = QueryOptions.two.request.urlComponents?.queryItems {
      XCTAssertEqual(optionOneQueryFields.first?.debugDescription, "first=firstQuery")
      XCTAssertEqual(optionTwoQueryFields.first?.debugDescription, "second=secondQuery")
    }
  }
  
  func testForLoopStatementWorkingForBuildEitherInQueryBuilder() {
    let fields = [
      "first": "firstQuery",
      "second": "secondQuery",
      "third": "thirdQuery"
    ]
    
    let request = Request {
      URL {
        Query {
          for field in fields {
            Field(field.value, forKey: field.key)
          }
        }
      }
    }
    
    var mockQueryItems: [URLQueryItem] = []
    for field in fields {
      mockQueryItems.append(URLQueryItem(name: field.key, value: field.value))
    }
    
    if let queryItems = request.urlComponents?.queryItems {
      XCTAssertEqual(queryItems, mockQueryItems)
    }
  }
}
