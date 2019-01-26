
protocol HTTPRequestType {

  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var parameters: HTTPRequestParameters? { get }

}

extension HTTPRequestType {

  var headers: [String: String]? {
    return nil
  }

  var parameters: HTTPRequestParameters? {
    return nil
  }

  var url: URL {
    return baseURL.appendingPathComponent(path)
  }

}
