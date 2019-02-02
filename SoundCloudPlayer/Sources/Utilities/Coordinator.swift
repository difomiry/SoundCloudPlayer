
import RxSwift

class Coordinator<Result> {

  func start() -> Observable<Result> {
    fatalError()
  }

  func coordinate<T>(to coordinator: Coordinator<T>) -> Observable<T> {
    return coordinator.start()
  }

}
