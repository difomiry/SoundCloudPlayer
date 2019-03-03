
import UIKit
import RxSwift
import Net

enum ImageSize: String {
  case large
  case t500x500
}

protocol SoundCloudServiceType: class {
  func search(query: String) -> Observable<[Track]>
  func fetchArtwork(path: String?, with size: ImageSize) -> Observable<UIImage>
  func fetchTrack(id: Int) -> Observable<Track>
  func fetchStreamURL(id: Int) -> Observable<URL>
}

final class SoundCloudService: SoundCloudServiceType {

  private let net: NetType

  init(net: NetType) {
    self.net = net
  }

  func search(query: String) -> Observable<[Track]> {
    return request(.search(query: query))
      .map { response in try response.data.map([Track].self) }
  }

  func fetchArtwork(path: String?, with size: ImageSize) -> Observable<UIImage> {
    let _path = path?.replacingOccurrences(of: "large", with: size.rawValue)
    guard let path = _path, let url = URL(string: path) else {
      return .just(UIImage(named: "Artwork")!)
    }
    return request(url)
      .map { response in UIImage(data: response.data) ?? UIImage(named: "Artwork")! }
  }

  func fetchTrack(id: Int) -> Observable<Track> {
    return request(.track(id: id))
      .map { response in try response.data.map(Track.self) }
  }

  func fetchStreamURL(id: Int) -> Observable<URL> {
    do {
      return Observable.just(try NetRequest(SoundCloud.stream(id: id)).buildURL())
    } catch {
      return Observable.error(error)
    }
  }

  fileprivate func request(_ target: SoundCloud) -> Observable<NetResponse> {
    return request(NetRequest(target))
  }

  fileprivate func request<Request: NetRequestType>(_ request: Request) -> Observable<NetResponse> {
    return Observable.create { observer in
      let task = self.net.request(request) { result in
        switch result {
        case let .success(response):
          observer.on(.next(response))
        case let .failure(error):
          observer.on(.error(error))
        }
      }
      return Disposables.create {
        task?.cancel()
      }
    }
  }

}
