import Foundation

public protocol QueryProtocol {
  func build(_ query: inout Query)
}

@resultBuilder
public struct QueryBuilder {
  public static func buildBlock(_ components: QueryProtocol...) -> QueryProtocol {
    CombinedQuery(components)
  }
  
  public static func buildArray(_ components: [QueryProtocol]) -> QueryProtocol {
    CombinedQuery(components)
  }
  
  public static func buildEither(first component: QueryProtocol) -> QueryProtocol {
    CombinedQuery([component])
  }
  
  public static func buildEither(second component: QueryProtocol) -> QueryProtocol {
    CombinedQuery([component])
  }
}

private struct CombinedQuery: QueryProtocol {
  private let children: [QueryProtocol]
  
  init(_ children: [QueryProtocol]) {
    self.children = children
  }
  
  func build(_ query: inout Query) {
    children.forEach {
      $0.build(&query)
    }
  }
}

public extension Query {
  init(@QueryBuilder _ fields: () -> QueryProtocol) {
    let combineQuery = fields()
    var queries = Query([:])
    combineQuery.build(&queries)
    self = queries
  }
}
