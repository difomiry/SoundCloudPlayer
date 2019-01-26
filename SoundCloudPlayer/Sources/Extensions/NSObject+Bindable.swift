
import UIKit

fileprivate struct AssociatedKeys {
  static var binder: UInt8 = 0
}

extension Bindable where Self: NSObject {

  private var binder: Observable<BindingType> {
    get {
      guard let value = objc_getAssociatedObject(self, &AssociatedKeys.binder) as? Observable<BindingType> else {
        let newValue = Observable<BindingType>()
        objc_setAssociatedObject(self, &AssociatedKeys.binder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return newValue
      }
      return value
    }
    set(newValue) {
      objc_setAssociatedObject(self, &AssociatedKeys.binder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  private func valueChanged() {
    if binder.value != observingValue {
      binder.value = observingValue
    }
  }

  func bind(to observable: Observable<BindingType>) {

    (self as? UIControl)?.addTarget(self, action: Selector { [weak self] in self?.valueChanged() }, for: [.editingChanged, .valueChanged])

    binder = observable

    if let value = observable.value {
      self.observingValue = value
    }

    observe(for: observable) { value in
      self.observingValue = value
    }
  }

}
