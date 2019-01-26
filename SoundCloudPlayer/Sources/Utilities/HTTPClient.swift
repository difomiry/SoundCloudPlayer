
class HTTPClient<RequestType: HTTPRequestType> {

  let session: URLSession

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  func task<ValueType: Decodable>(with request: RequestType, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<ValueType>) -> Void) {

    let urlRequest: URLRequest

    do {
      urlRequest = try prepare(request: request)
    } catch {
      return completion(.failure(error))
    }

    session.dataTask(with: urlRequest) { data, _, error in

      let result: Result<ValueType>

      defer {
        DispatchQueue.main.async {
          completion(result)
        }
      }

      switch (data, error) {
      case let (.some(data), .none):
        do {
          result = .success(try decoder.decode(ValueType.self, from: data))
        } catch {
          result = .failure(HTTPError.invalidResponse)
        }
      case let (.none, .some(error)):
        result = .failure(HTTPError.networkError(error))
      case (.none, .none), (.some, .some):
        result = .failure(HTTPError.invalidResponse)
      }
      }.resume()
  }

  private func prepare(request: HTTPRequestType) throws -> URLRequest {

    var urlRequest = URLRequest(url: request.url)

    if let parameters = request.parameters {
      switch parameters {
      case let .url(parameters):

        var urlComponents = URLComponents()

        urlComponents.queryItems = parameters.map { (key, value) -> URLQueryItem in
          return URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }

        guard let url = urlComponents.url(relativeTo: request.url) else {
          throw HTTPError.invalidRequest
        }

        urlRequest.url = url
      case let .body(parameters):
        do {
          urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .init(rawValue: 0))
        } catch {
          throw HTTPError.invalidRequest
        }
      }
    }

    return urlRequest
  }

}
