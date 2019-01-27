
class Observable<ObservedType> {

  typealias Observer = (Observable<ObservedType>, ObservedType) -> Void

  private var observers = [Observer]()

  var value: ObservedType? {
    didSet {
      if let value = value {
        observers.forEach { observer in observer(self, value) }
      }
    }
  }

  init(_ value: ObservedType? = nil) {
    self.value = value
  }

  func bind(to observer: @escaping Observer) {
    observers.append(observer)
  }

}
