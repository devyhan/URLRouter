import Foundation

public protocol BodyProtocol {
  func build(_ body: inout Body)
}

@resultBuilder
public struct BodyBuilder {
  public static func buildBlock(_ components: BodyProtocol...) -> BodyProtocol {
    CombinedBody(components)
  }
  
  public static func buildArray(_ components: [BodyProtocol]) -> BodyProtocol {
    CombinedBody(components)
  }
  
  public static func buildEither(first component: BodyProtocol) -> BodyProtocol {
    CombinedBody([component])
  }
  
  public static func buildEither(second component: BodyProtocol) -> BodyProtocol {
    CombinedBody([component])
  }
}

private struct CombinedBody: BodyProtocol {
  private let children: [BodyProtocol]
  
  init(_ children: [BodyProtocol]) {
    self.children = children
  }
  
  func build(_ body: inout Body) {
    children.forEach {
      $0.build(&body)
    }
  }
}

public extension Body {
  init(@BodyBuilder _ params: () -> BodyProtocol) {
    let combineBody = params()
    var body = Body([:])
    combineBody.build(&body)
    self = body
  }
}
