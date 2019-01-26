
enum HTTPError: Error {

  case invalidRequest
  case invalidResponse
  case networkError(Error)

  var localizedDescription: String {
    switch self {
    case .invalidRequest:
      return "Invalid Request"
    case .invalidResponse:
      return "Invalid Response"
    case let .networkError(error):
      return "Network error:\n\(error.localizedDescription)"
    }
  }

}
