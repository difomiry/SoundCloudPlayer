
enum SoundCloudService {

  case track(Int)
  case search(String)

}

extension SoundCloudService: HTTPRequestType {
  
  var baseURL: URL {
    return URL(string: "https://api.soundcloud.com/")!
  }

  var path: String {
    switch self {
    case let .track(id):
      return "tracks/\(id)"
    case .search:
      return "tracks"
    }
  }

  var parameters: HTTPRequestParameters? {

    var parameters = ["client_id": "xkpqYPmDf6KG7aL1xM4qfWaJQrHBLSOh"]

    switch self {
    case let .search(query):
      parameters["limit"] = "50"
      parameters["q"] = query
    default:
      break
    }

    return .url(parameters)
  }

}
