
import RxSwift

extension HTTPClient: ReactiveCompatible {}

extension Reactive where Base: HTTPClientType {

  func task<Request: HTTPRequestType, Response: HTTPResponseType>(request: Request, type: Response.Type) -> Observable<Response> {
    return Observable.create { observer in
      let task = self.base.task(request: request, type: type) { result in
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
