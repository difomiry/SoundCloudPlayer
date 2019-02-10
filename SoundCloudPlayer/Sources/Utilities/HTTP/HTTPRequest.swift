
import Foundation

protocol HTTPRequestType {
  func buildURL() throws -> URL
  func buildURLRequest() throws -> URLRequest
}

class HTTPRequest<Target: HTTPTargetType>: HTTPRequestType {

  private let target: Target

  required init(_ target: Target) {
    self.target = target
  }

  func buildURL() throws -> URL {

    var _url = target.baseURL

    if let path = target.path {
      _url.appendPathComponent(path)
    }

    guard var urlComponents = URLComponents(url: _url, resolvingAgainstBaseURL: true) else {
      throw HTTPError.invalidRequest
    }

    if let parameters = target.parameters {
      urlComponents.queryItems = parameters.map { (key, value) -> URLQueryItem in
        return URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
      }
    }

    guard let url = urlComponents.url else {
      throw HTTPError.invalidRequest
    }

    return url
  }

  func buildURLRequest() throws -> URLRequest {

    var urlRequest = URLRequest(url: try buildURL())

    if let body = target.body {
      urlRequest.httpBody = body
    }

    target.headers?.forEach { (key, value) in urlRequest.addValue(value, forHTTPHeaderField: key) }

    urlRequest.httpMethod = target.method.rawValue

    return urlRequest
  }

}
