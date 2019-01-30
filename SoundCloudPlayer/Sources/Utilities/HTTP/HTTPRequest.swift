
import Foundation

protocol HTTPRequestType {

  associatedtype Target: HTTPTargetType

  init(target: Target)

  func url() throws -> URL
  func request() throws -> URLRequest

}

class HTTPRequest<Target: HTTPTargetType>: HTTPRequestType {

  private let target: Target

  required init(target: Target) {
    self.target = target
  }

  func url() throws -> URL {

    var _url = target.baseURL

    if let path = target.path {
      _url.appendPathComponent(path)
    }

    guard var urlComponents = URLComponents(url: _url, resolvingAgainstBaseURL: true) else {
      throw HTTPError.invalidRequest
    }

    if case let .url(parameters)? = target.task {
      urlComponents.queryItems = parameters.map { (key, value) -> URLQueryItem in
        return URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
      }
    }

    guard let url = urlComponents.url else {
      throw HTTPError.invalidRequest
    }

    return url
  }

  func request() throws -> URLRequest {

    var urlRequest = URLRequest(url: try url())

    if case let .body(data)? = target.task {
      urlRequest.httpBody = data
    }

    target.headers?.forEach { (key, value) in urlRequest.addValue(value, forHTTPHeaderField: key) }

    urlRequest.httpMethod = target.method.rawValue

    return urlRequest
  }

}
