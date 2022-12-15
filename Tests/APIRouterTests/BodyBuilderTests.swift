import Foundation
import XCTest
@testable import APIRouter

final class BodyBuilderTests: XCTestCase {
  func testSwitchConditionalStatementWorkingForBuildEitherInBodyBuilder() {
    enum BodyOptions {
      case one
      case two
      
      var request: Request {
        Request {
          Body {
            switch self {
            case .one:
              Param("VALUE", forKey: "OPTIONONE")
            case .two:
              Param("VALUE", forKey: "OPTIONTWO")
            }
          }
        }
      }
    }
    
    if let optionOneBody = BodyOptions.one.request.urlRequest?.httpBody,
       let optionOneBodyString = String(data: optionOneBody, encoding: .utf8),
       let optionTwoBody = BodyOptions.two.request.urlRequest?.httpBody,
       let optionTwoBodyString = String(data: optionTwoBody, encoding: .utf8) {
      XCTAssertEqual(optionOneBodyString, "{\"OPTIONONE\":\"VALUE\"}")
      XCTAssertEqual(optionTwoBodyString, "{\"OPTIONTWO\":\"VALUE\"}")
    }
  }
  
  func testIfConditionalStatementWorkingForBuildEitherInUrlBuilder() {
    enum BodyOptions {
      case one
      case two
      
      var request: Request {
        Request {
          Body {
            if self == .one {
              Param("VALUE", forKey: "OPTIONONE")
            } else {
              Param("VALUE", forKey: "OPTIONTWO")
            }
          }
        }
      }
    }
    
    if let optionOneBody = BodyOptions.one.request.urlRequest?.httpBody,
       let optionOneBodyString = String(data: optionOneBody, encoding: .utf8),
       let optionTwoBody = BodyOptions.two.request.urlRequest?.httpBody,
       let optionTwoBodyString = String(data: optionTwoBody, encoding: .utf8) {
      XCTAssertEqual(optionOneBodyString, "{\"OPTIONONE\":\"VALUE\"}")
      XCTAssertEqual(optionTwoBodyString, "{\"OPTIONTWO\":\"VALUE\"}")
    }
  }
  
  func testForLoopStatementWorkingForBuildEitherInBodyBuilder() {
    let params = [
      "key1": "value1",
      "key2": "value2",
      "key3": "value3",
      "key4": "value4",
    ]
    
    let request = Request {
      Body {
        for param in params {
          Param(param.value, forKey: param.key)
        }
      }
    }
    
    if let httpBody = request.urlRequest?.httpBody,
      let bodyString = String(data: httpBody, encoding: .utf8) {
      XCTAssertEqual(bodyString.sorted(), ["\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", ",", ",", ",", "1", "1", "2", "2", "3", "3", "4", "4", ":", ":", ":", ":", "a", "a", "a", "a", "e", "e", "e", "e", "e", "e", "e", "e", "k", "k", "k", "k", "l", "l", "l", "l", "u", "u", "u", "u", "v", "v", "v", "v", "y", "y", "y", "y", "{", "}"])
    }
  }
}
