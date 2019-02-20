
import Net

enum SoundCloud {
  case track(id: Int)
  case stream(id: Int)
  case search(query: String)
}

extension SoundCloud: TargetType {
  
  var baseURLString: String {
    return AppConstants.SoundCloud.path
  }

  var path: String? {
    switch self {
    case let .track(id):
      return "tracks/\(id)"
    case let .stream(id):
      return "tracks/\(id)/stream"
    case .search:
      return "tracks"
    }
  }

  var parameters: Parameters? {

    var parameters: Parameters = [:]

    switch self {
    case let .search(query):
      parameters["limit"] = AppConstants.SoundCloud.searchLimit
      parameters["q"] = query
    default:
      break
    }

    return parameters
  }

  var credentials: Credentials? {
    return .apiKey("client_id", AppConstants.SoundCloud.key)
  }

}
