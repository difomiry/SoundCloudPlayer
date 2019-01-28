
import RxSwift

protocol SoundCloudServiceType {

  func search(query: String) -> Observable<[Track]>
  func fetchTrack(id: Int) -> Observable<Track>
  func fetchStreamUrl(id: Int) -> Observable<URL>

}

final class SoundCloudService: HTTPClient<SoundCloudRequest>, SoundCloudServiceType {

  private let provider: ServiceProviderType

  init(provider: ServiceProviderType) {
    self.provider = provider
  }

  func search(query: String) -> Observable<[Track]> {
    return Observable.create { [weak self] observer in
      self?.task(with: .search(query)) { (result: Result<[Track]>) in
        switch result {
        case let .success(tracks):
          observer.on(.next(tracks))
        case let .failure(error):
          observer.on(.error(error))
        }
      }
      return Disposables.create()
    }
  }

  func fetchTrack(id: Int) -> Observable<Track> {
    return Observable.create { [weak self] observer in
      self?.task(with: .track(id)) { (result: Result<Track>) in
        switch result {
        case let .success(track):
          observer.on(.next(track))
        case let .failure(error):
          observer.on(.error(error))
        }
      }
      return Disposables.create()
    }
  }

  func fetchStreamUrl(id: Int) -> Observable<URL> {
    return Observable.create { [weak self] observer in
      guard let `self` = self else {
        return Disposables.create()
      }
      do {
        observer.on(.next(try self.prepareUrl(from: .stream(id))))
      } catch {
        observer.on(.error(error))
      }
      return Disposables.create()
    }
  }

}
