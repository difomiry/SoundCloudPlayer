
import Foundation

protocol HTTPClientType {

  init(session: URLSession, queue: DispatchQueue)

  func task<Request: HTTPRequestType, Response: HTTPResponseType>(request: Request, type: Response.Type, completion: @escaping (Result<Response, HTTPError>) -> Void) -> URLSessionDataTask?

}

class HTTPClient: HTTPClientType {

  private let session: URLSession
  private let queue: DispatchQueue

  required init(session: URLSession = .shared, queue: DispatchQueue = .main) {
    self.session = session
    self.queue = queue
  }

  func task<Request: HTTPRequestType, Response: HTTPResponseType>(request: Request, type: Response.Type, completion: @escaping (Result<Response, HTTPError>) -> Void) -> URLSessionDataTask? {

    func _completion(result: Result<Response, HTTPError>) {
      self.queue.async {
        completion(result)
      }
    }

    let urlRequest: URLRequest

    do {
      urlRequest = try request.request()
    } catch {
      _completion(result: .failure(HTTPError.invalidRequest))
      return nil
    }

    let task = session.dataTask(with: urlRequest) { data, _, error in
      switch (data, error) {
      case let (.some(data), .none):
        _completion(result: .success(Response.init(data: data)))
      case let (.none, .some(error)):
        _completion(result: .failure(HTTPError.networkError(error)))
      case (.none, .none), (.some, .some):
        _completion(result: .failure(HTTPError.invalidResponse))
      }
    }
    task.resume()

    return task
  }

}
