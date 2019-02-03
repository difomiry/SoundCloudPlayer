
import RxSwift

protocol NetworkServiceType: class {
  func task<Request: HTTPRequestType>(request: Request) -> Observable<HTTPResponse>
}

final class NetworkService: NetworkServiceType {

  private let httpClient: HTTPClientType

  init(httpClient: HTTPClientType = ServiceLocator.shared.httpClient) {
    self.httpClient = httpClient
  }

  func task<Request: HTTPRequestType>(request: Request) -> Observable<HTTPResponse> {
    return Observable.create { observer in
      let task = self.httpClient.task(request: request) { result in
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
