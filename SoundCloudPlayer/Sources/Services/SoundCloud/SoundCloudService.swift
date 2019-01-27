
final class SoundCloudService {

  private let httpClient: HTTPClient<SoundCloudRequest>

  init(provider: ServiceProvider) {
    httpClient = provider.httpClient
  }

  func search(query: String, completion: @escaping (Result<[Track]>) -> Void) {
    httpClient.task(with: .search(query), completion: completion)
  }

  func fetchTrack(id: Int, completion: @escaping (Result<Track>) -> Void) {
    httpClient.task(with: .track(id), completion: completion)
  }

  func fetchStreamUrl(id: Int, completion: @escaping (Result<URL>) -> Void) {

    let result: Result<URL>

    defer {
      DispatchQueue.main.async {
        completion(result)
      }
    }

    do {
      result = .success(try httpClient.prepareUrl(from: .stream(id)))
    } catch {
      result = .failure(error)
    }
  }

}
