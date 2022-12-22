![main](https://github.com/devyhan/urlrouter/actions/workflows/ci.yml/badge.svg?branch=main)
[![codecov](https://codecov.io/gh/devyhan/URLRouter/branch/main/graph/badge.svg?token=ZQNDOX2VDF)](https://codecov.io/gh/devyhan/APIRouter)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdevyhan%2FAPIRouter%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/devyhan/APIRouter)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdevyhan%2FAPIRouter%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/devyhan/APIRouter)

<p align="center">
  <img src="https://user-images.githubusercontent.com/45344633/208562346-19b44df3-c581-4f32-af8e-d85dbc99ec18.png" />
</p>

## What's URLRouter 📟
***URLRouter*** is provides an easy way to manage multiple URL endpoints in Swift.
It provides a simple interface for managing multiple endpoints and allows developers to interact with them in a single, unified manner.
It also provides a way for developers to create custom endpoints DSL(Domain-Specific Languages) and to manage their own settings for each endpoint.
Additionally, it provides a way to track the status of each endpoint and to easily detect any changes or updates that have been made.

Similar to Swift Evolution's [Regex builder DSL](https://github.com/apple/swift-evolution/blob/main/proposals/0351-regex-builder.md), URL string literal and a more powerful pattern result builder to help make Swift URL string processing fast and easy and without mistakes. Ultimately, with ***APIRouter***, changes are easy to detect and useful for maintenance.

🤔 *Ask questions you’re wondering about [here](https://github.com/devyhan/URLRouter/discussions/new?category=q-a).*<br/>
💡 *Share ideas [here](https://github.com/devyhan/APIRouter/discussions/new).*

## Installation 📦
- Using [Swift Package Manager](https://swift.org/package-manager)

    ```swift
    import PackageDescription

    let package = Package(
      name: "SomeApp",
      dependencies: [
        .Package(url: "https://github.com/devyhan/URLRouter", majorVersion: "<LATEST_RELEASES_VERSION>"),
      ]
    )
    ```

## Configure URLRouter 📝
### Implement URLs Namespace 
- To implement URLs namespace we create a new type that will house the domain and behavior of the URLs by conforming to `RouterProtocol`.
```swift
import URLRouter

public enum URLs: RouterProtocol {
  ...
}
```
### HttpHeader declaration
- Using `HeaderBuilder` to `httpHeader` declaration.
```swift
Request {
  ...
  Header {
    Field("HEADERVALUE", forKey: "HEADERKEY")
    Field("HEADERVALUE1", forKey: "HEADERKEY1")
    Field("HEADERVALUE2", forKey: "HEADERKEY2")
    ...
  }
  ...
}
```
- Using `Dictionary` to `httpHeader` declaration.
```swift
Request {
  ...
  Header([
    "HEADERKEY": "HEADERVALUE",
    "HEADERKEY1": "HEADERVALUE1",
    "HEADERKEY2": "HEADERVALUE2",
    ...
  ])
  ...
}
```
---
### HttpBody declaration
- Using `HeaderBuilder` to `httpHeader` declaration.
```swift
Request {
  ...
  Body {
    Field("VALUE", forKey: "KEY")
    Field("VALUE1", forKey: "KEY1")
    Field("VALUE2", forKey: "KEY2")
    ...
  }
  ...
}
```
- Using `Dictionary<String, Any>` to `httpHeader` declaration.
```swift
Request {
  ...
  Body([
    "KEY": "VALUE",
    "KEY1": "VALUE1",
    "KEY2": "VALUE2",
    ...
  ])
  ...
}
```
---
### HttpMethod declaration
- Using `Method(_ method:)` to `httpMethod` declaration.
```swift
Request {
  ...
  Method(.get)
  ...
}
```
- Using `static let method:` to `httpMethod` declaration.
```swift
Request {
  ...
  Method.get
  ...
}
```
---
### URL declaration
- Using `URL(_ url:)` to `URL` declaration.
```swift 
Request {
  ...
  URL("https://www.baseurl.com/comments?postId=1")
  ...
}
```
- Using `URLBuilder`  to `URL` declaration and `URLComponents` declaration.
```swift
Request {
  ...
  URL {
    Scheme(.https)
    Host("www.baseurl.com")
    Path("comments")
    Query("postId", value: "1")
  }
  ...
}
// https://www.baseurl.com/comments?postId=1
```
- Using `BaseURL(_ url:)` for `URL` override.
```swift
Request {
  BaseURL("https://www.baseurl.com")
  URL {
    Path("comments")
    Query("postId", value: "1")
  }
}
// https://www.baseurl.com/comments?postId=1

Router {
  BaseURL("https://www.baseurl.com")
  Request {
    URL {
      Scheme(.https)
      Host("www.overrideurl.com")
      Path("comments")
      Query("postId", value: "1")
    }
  }
}
// https://www.overrideurl.com/comments?postId=1
```
#### URL Scheme declaration
- Using `Scheme(_ scheme:)` to `Scheme` declaration.
```swift 
Request {
  ...
  URL {
    Scheme(.https)
    ...
  }
  ...
}
```
- Using `static let scheme:` to `Scheme` declaration.
```swift 
Request {
  ...
  URL {
    Scheme.https
    ...
  }
  ...
}
```
#### URL Query declaration
- Using `Dictionary<String, String?>` to `Query` declaration.
```swift
Request {
  ...
  URL {
    Query(
      [
        "first": "firstQuery",
        "second": "secondQuery",
        ...
      ]
    )
  }
  ...
}
```
- Using `Query(_, value:)` to `Query` declaration.
```swift
Request {
  ...
  URL {
    Query("test", value: "query")
    Query("test", value: "query")
    ...
  }
  ...
}
```
- Using `Field(_, forKey:)` to `Query` declaration.
```swift
Request {
  ...
  URL {
    Query {
      Field("firstQuery", forKey: "first")
      Field("secondQuery", forKey: "second")
      ...
    }
    ...
  }
  ...
}
```
---
### How to configure and use ***URLRouter*** in a real world project?
- Just create URLRouter.swift in your project! Happy hacking! 😁
```swift
import URLRouter

enum URLs: RouterProtocol {
  // DOC: https://docs.github.com/ko/rest/repos/repos?apiVersion=2022-11-28#list-organization-repositories
  case listOrganizationRepositories(organizationName: String)
  // DOC: https://docs.github.com/ko/rest/repos/repos?apiVersion=2022-11-28#create-an-organization-repository
  case createAnOrganizationRepository(organizationName: String, repositoryInfo: RepositoryInfo)
  // DOC: https://docs.github.com/ko/rest/search?apiVersion=2022-11-28#search-repositories
  case searchRepositories(query: String)
  case deeplink(path: String = "home")

  struct RepositoryInfo {
    let name: String
    let description: String
    let homePage: String
    let `private`: Bool
    let hasIssues: Bool
    let hasProjects: Bool
    let hasWiki: Bool
  }
  
  var router: Router? {
    Router {
      BaseURL("http://api.github.com")
      switch self {
      case let .listOrganizationRepositories(organizationName):
        Request {
          Method.post
          Header {
            Field("application/vnd.github+json", forKey: "Accept")
            Field("Bearer <YOUR-TOKEN>", forKey: "Authorization")
            Field("2022-11-28", forKey: "X-GitHub-Api-Version")
          }
          URL {
            Path("orgs/\(organizationName)/repos")
          }
        }
      case let .createAnOrganizationRepository(organizationName, repositoryInfo):
        Request {
          Method.post
          Header {
            Field("application/vnd.github+json", forKey: "Accept")
            Field("Bearer <YOUR-TOKEN>", forKey: "Authorization")
            Field("2022-11-28", forKey: "X-GitHub-Api-Version")
          }
          URL {
            Path("orgs/\(organizationName)/repos")
          }
          Body {
            Field(repositoryInfo.name, forKey: "name")
            Field(repositoryInfo.description, forKey: "description")
            Field(repositoryInfo.homePage, forKey: "homepage")
            Field(repositoryInfo.private, forKey: "private")
            Field(repositoryInfo.hasIssues, forKey: "has_issues")
            Field(repositoryInfo.hasProjects, forKey: "has_projects")
            Field(repositoryInfo.hasWiki, forKey: "has_wiki")
          }
        }
      case let .searchRepositories(query):
        Request {
          Method.get
          Header {
            Field("application/vnd.github+json", forKey: "Accept")
            Field("Bearer <YOUR-TOKEN>", forKey: "Authorization")
            Field("2022-11-28", forKey: "X-GitHub-Api-Version")
          }
          URL {
            Path("search/repositories")
            Query("q", value: query)
          }
        }
      case let .deeplink(path):
        URL {
          Scheme.custom("example-deeplink")
          Host("detail")
          Path(path)
          Query {
            Field("postId", forKey: "1")
            Field("createdAt", forKey: "2021-04-27T04:39:54.261Z")
          }
        }
      }
    }
  }
}

// http://api.github.com/orgs/organization/repos
let listOrganizationRepositoriesUrl = URLs.listOrganizationRepositories(organizationName: "organization").router?.urlRequest?.url

// http://api.github.com/search/repositories?q=urlrouter
let searchRepositoriesUrl = URLs.searchRepositories(query: "urlrouter").router?.urlRequest?.url

// example-deeplink://detail/comments?1=postId&2021-04-27T04:39:54.261Z=createdA
let deeplink = URLs.deeplink(path: "detail").router.url
```
- Using ***URLRouter*** to provide `URLRequest`.
```swift
let repositoryInfo: URLs.RepositoryInfo = .init(name: "Hello-World", description: "This is your first repository", homePage: "https://github.com", private: false, hasIssues: true, hasProjects: true, hasWiki: false)
let request = URLs.createAnOrganizationRepository(organizationName: "SomeOrganization", repositoryInfo: repositoryInfo).router?.urlRequest

URLSession.shared.dataTask(with: request) { data, response, error in
...
```
- Using ***URLRouter*** to provide deeplink `URL` and check to match this `URL`.
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
  ... 
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    let detailDeeplink = URLs.deeplink(path: "detail").router.url
    if detailDeeplink == url {
      ...
    }
  ...
```
## License

***URLRouter*** is under MIT license. See the [LICENSE](LICENSE) file for more info.

---
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/devyhan/urlrouter?style=social)
[![Twitter Follow @devyhan93](https://img.shields.io/twitter/follow/devyhan93?style=social)](https://twitter.com/devyhan93)