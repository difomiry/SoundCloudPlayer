
import Foundation

typealias HTTPResult = Result<HTTPResponse, HTTPError>

typealias HTTPCompletion = (HTTPResult) -> Void

protocol HTTPClientType {
  func request<Request: HTTPRequestType>(_ request: Request, completion: @escaping HTTPCompletion) -> URLSessionDataTask?
}

class HTTPClient: HTTPClientType {

  static let `default` = HTTPClient()

  private let session: URLSession
  private let queue: DispatchQueue

  required init(session: URLSession = .shared, queue: DispatchQueue = .main) {
    self.session = session
    self.queue = queue
  }

  @discardableResult
  func request<Request: HTTPRequestType>(_ request: Request, completion: @escaping HTTPCompletion) -> URLSessionDataTask? {

    func _completion(result: HTTPResult) {
      self.queue.async {
        completion(result)
      }
    }

    let urlRequest: URLRequest

    do {
      urlRequest = try request.buildURLRequest()
    } catch {
      _completion(result: .failure(HTTPError.invalidRequest))
      return nil
    }

    let task = session.dataTask(with: urlRequest) { data, response, error in
      switch (data, response as? HTTPURLResponse, error) {
      case let (.some(data), .some(response), .none):
        _completion(result: .success(HTTPResponse(code: response.statusCode, data: data)))
      case let (.none, .none, .some(error)):
        _completion(result: .failure(HTTPError.networkError(error)))
      default:
        _completion(result: .failure(HTTPError.invalidResponse))
      }
    }
    task.resume()

    return task
  }

}
