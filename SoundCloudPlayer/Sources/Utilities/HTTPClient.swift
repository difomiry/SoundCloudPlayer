
class HTTPClient<RequestType: HTTPRequestType> {

  let session: URLSession

  init(session: URLSession = URLSession.shared) {
    self.session = session
  }

  func task<ValueType: Decodable>(with request: RequestType, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (Result<ValueType>) -> Void) {

    let urlRequest: URLRequest

    do {
      urlRequest = try prepareUrlRequest(from: request)
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

  func prepareUrl(from request: RequestType) throws -> URL {

    guard var urlComponents = URLComponents(url: request.url, resolvingAgainstBaseURL: true) else {
      throw HTTPError.invalidRequest
    }

    if let parameters = request.parameters {
      switch parameters {
      case let .url(parameters):
        urlComponents.queryItems = parameters.map { (key, value) -> URLQueryItem in
          return URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }
      default:
        break
      }
    }

    guard let url = urlComponents.url else {
      throw HTTPError.invalidRequest
    }

    return url
  }

  func prepareUrlRequest(from request: RequestType) throws -> URLRequest {

    var urlRequest = URLRequest(url: try prepareUrl(from: request))

    if let parameters = request.parameters {
      switch parameters {
      case let .body(parameters):
        do {
          urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .init(rawValue: 0))
        } catch {
          throw HTTPError.invalidRequest
        }
      default:
        break
      }
    }

    urlRequest.httpMethod = request.method.rawValue

    return urlRequest
  }

}
