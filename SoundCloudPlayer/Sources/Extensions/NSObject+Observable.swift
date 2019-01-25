
import Foundation

extension NSObject {

  func observe<ObservedType>(for observable: Observable<ObservedType>, with handler: @escaping (ObservedType) -> ()) {
    observable.bind { observable, value  in
      DispatchQueue.main.async {
        handler(value)
      }
    }
  }

}
