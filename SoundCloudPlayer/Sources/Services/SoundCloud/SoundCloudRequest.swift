
enum SoundCloudRequest {

  case track(Int)
  case stream(Int)
  case search(String)

}

extension SoundCloudRequest: HTTPRequestType {
  
  var baseURL: URL {
    return URL(string: AppConstants.soundCloudApiPath)!
  }

  var path: String {
    switch self {
    case let .track(id):
      return "tracks/\(id)"
    case let .stream(id):
      return "tracks/\(id)/stream"
    case .search:
      return "tracks"
    }
  }

  var parameters: HTTPRequestParameters? {

    var parameters = ["client_id": AppConstants.soundCloudApiKey]

    switch self {
    case let .search(query):
      parameters["limit"] = String(AppConstants.soundCloudApiSearchLimit)
      parameters["q"] = query
    default:
      break
    }

    return .url(parameters)
  }

}
