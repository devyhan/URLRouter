import Foundation
import XCTest
@testable import APIRouter

final class BodyBuilderTests: XCTestCase {
  func testSwitchConditionalStatementWorkingForBuildEitherInBodyBuilder() {
    enum BodyOptions {
      case one
      case two
    }
    
    let options: BodyOptions = .one
    
    let request = Request {
      Body {
        switch options {
        case .one:
          Param("VALUE", forKey: "OPTIONONE")
        case .two:
          Param("VALUE", forKey: "OPTIONTWO")
        }
      }
    }
    
    guard
      let httpBody = request.urlRequest?.httpBody,
      let bodyString = String(data: httpBody, encoding: .utf8)
    else { return }
    
    XCTAssertEqual(bodyString, "{\"OPTIONONE\":\"VALUE\"}")
  }
  
  func testIfConditionalStatementWorkingForBuildEitherInUrlBuilder() {
    let conditional = true
    
    let request = Request {
      Body {
        if conditional == true {
          Param("VALUE", forKey: "OPTIONONE")
        } else {
          Param("VALUE", forKey: "OPTIONTWO")
        }
      }
    }
    
    guard
      let httpBody = request.urlRequest?.httpBody,
      let bodyString = String(data: httpBody, encoding: .utf8)
    else { return }
    
    XCTAssertEqual(bodyString, "{\"OPTIONONE\":\"VALUE\"}")
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
    
    guard
      let httpBody = request.urlRequest?.httpBody,
      let bodyString = String(data: httpBody, encoding: .utf8)
    else { return }
    
    XCTAssertEqual(bodyString.sorted(), ["\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", ",", ",", ",", "1", "1", "2", "2", "3", "3", "4", "4", ":", ":", ":", ":", "a", "a", "a", "a", "e", "e", "e", "e", "e", "e", "e", "e", "k", "k", "k", "k", "l", "l", "l", "l", "u", "u", "u", "u", "v", "v", "v", "v", "y", "y", "y", "y", "{", "}"])
  }
}
