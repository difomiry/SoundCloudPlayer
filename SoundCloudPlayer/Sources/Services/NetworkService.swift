
import RxSwift

protocol NetworkServiceType: class {
  func request<Request: HTTPRequestType>(_ request: Request) -> Observable<HTTPResponse>
}

final class NetworkService: NetworkServiceType {

  private let httpClient: HTTPClientType

  init(httpClient: HTTPClientType = ServiceLocator.shared.httpClient) {
    self.httpClient = httpClient
  }

  func request<Request: HTTPRequestType>(_ request: Request) -> Observable<HTTPResponse> {
    return Observable.create { observer in
      let task = self.httpClient.request(request) { result in
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
