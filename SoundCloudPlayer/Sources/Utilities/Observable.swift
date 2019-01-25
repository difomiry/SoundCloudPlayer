
import Foundation

class Observable<ObservedType> {

  typealias Observer = (_ observable: Observable<ObservedType>, ObservedType) -> Void

  private var observers = [Observer]()

  var value: ObservedType? {
    didSet {
      if let value = value {
        notify(value)
      }
    }
  }

  init(_ value: ObservedType? = nil) {
    self.value = value
  }

  func bind(_ observer: @escaping Observer) {
    observers.append(observer)
  }

  private func notify(_ value: ObservedType) {
    observers.forEach { [unowned self] observer in
      observer(self, value)
    }
  }

}
