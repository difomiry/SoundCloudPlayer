
protocol SoundCloudServiceType {

  func search(query: String, completion: @escaping (Result<[Track]>) -> Void)
  func fetchTrack(id: Int, completion: @escaping (Result<Track>) -> Void)
  func fetchStreamUrl(id: Int, completion: @escaping (Result<URL>) -> Void)

}

final class SoundCloudService: HTTPClient<SoundCloudRequest>, SoundCloudServiceType {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  func search(query: String, completion: @escaping (Result<[Track]>) -> Void) {
    task(with: .search(query), completion: completion)
  }

  func fetchTrack(id: Int, completion: @escaping (Result<Track>) -> Void) {
    task(with: .track(id), completion: completion)
  }

  func fetchStreamUrl(id: Int, completion: @escaping (Result<URL>) -> Void) {

    let result: Result<URL>

    defer {
      DispatchQueue.main.async {
        completion(result)
      }
    }

    do {
      result = .success(try prepareUrl(from: .stream(id)))
    } catch {
      result = .failure(error)
    }
  }

}
