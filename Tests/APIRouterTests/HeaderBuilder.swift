import Foundation
import XCTest
@testable import APIRouter

final class HeaderBuilderTests: XCTestCase {
  func testSwitchConditionStatemntWorkingForBuildEitherInHeaderBuilder() {
    enum HeaderOptions {
      case one
      case two

      var request: Request {
        Request {
          Header {
            switch self {
            case .one:
              Field("VALUE", forKey: "OPTIONONE")
            case .two:
              Field("VALUE", forKey: "OPTIONTWO")
            }
          }
        }
      }
    }
    
    if let optionOneHeaderFields = HeaderOptions.one.request.urlRequest?.allHTTPHeaderFields,
       let optionTwoHeaderFields = HeaderOptions.two.request.urlRequest?.allHTTPHeaderFields {
      XCTAssertEqual(optionOneHeaderFields, ["OPTIONONE":"VALUE"])
      XCTAssertEqual(optionTwoHeaderFields, ["OPTIONTWO":"VALUE"])
    }
  }
  
  func testIfConditionalStatementWorkingForBuildEitherInUrlBuilder() {
    enum HeaderOptions {
      case one
      case two

      var request: Request {
        Request {
          Header {
            if self == .one {
              Field("VALUE", forKey: "OPTIONONE")
            } else {
              Field("VALUE", forKey: "OPTIONTWO")
            }
          }
        }
      }
    }
    
    if let optionOneHeaderFields = HeaderOptions.one.request.urlRequest?.allHTTPHeaderFields,
       let optionTwoHeaderFields = HeaderOptions.two.request.urlRequest?.allHTTPHeaderFields {
      XCTAssertEqual(optionOneHeaderFields, ["OPTIONONE":"VALUE"])
      XCTAssertEqual(optionTwoHeaderFields, ["OPTIONTWO":"VALUE"])
    }
  }
  
  func testForLoopStatementWorkingForBuildEitherInHeaderBuilder() {
    let fields = [
      "key1": "value1",
      "key2": "value2",
      "key3": "value3",
      "key4": "value4",
    ]
    
    let request = Request {
      Header {
        for field in fields {
          Field(field.value, forKey: field.key)
        }
      }
    }
    
    if let sortedAllHTTPHeaderFields = request.urlRequest?.allHTTPHeaderFields {
      XCTAssertEqual(sortedAllHTTPHeaderFields, ["key1": "value1", "key2": "value2", "key3": "value3", "key4": "value4"])
    }
  }
}
