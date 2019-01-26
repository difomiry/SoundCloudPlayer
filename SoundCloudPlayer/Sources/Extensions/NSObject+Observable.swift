
extension NSObject {

  func observe<ObservedType>(for observable: Observable<ObservedType>, with handler: @escaping (ObservedType) -> ()) {
    observable.bind { _, value  in
      DispatchQueue.main.async {
        handler(value)
      }
    }
  }

}
