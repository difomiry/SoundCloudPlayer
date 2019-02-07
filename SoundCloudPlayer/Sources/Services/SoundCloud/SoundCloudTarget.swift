
import Foundation

enum SoundCloudTarget {
  case track(id: Int)
  case stream(id: Int)
  case search(query: String)
}

extension SoundCloudTarget: HTTPTargetType {
  
  var baseURL: URL {
    return URL(string: AppConstants.SoundCloud.path)!
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

  var task: HTTPTargetTask? {

    var parameters = ["client_id": AppConstants.SoundCloud.key]

    switch self {
    case let .search(query):
      parameters["limit"] = String(AppConstants.SoundCloud.searchLimit)
      parameters["q"] = query
    default:
      break
    }

    return .url(parameters: parameters)
  }

}
