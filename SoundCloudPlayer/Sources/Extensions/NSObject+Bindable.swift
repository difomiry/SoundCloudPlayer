
import UIKit

fileprivate struct AssociatedKeys {
  static var binder: UInt8 = 0
}

extension Bindable where Self: NSObject {

  private var binder: Observable<BindingType>? {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.binder) as? Observable<BindingType>
    }
    set {
      if let newValue = newValue {
        objc_setAssociatedObject(self, &AssociatedKeys.binder, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
    }
  }

  func observe(for observable: Observable<BindingType>, with handler: @escaping (BindingType) -> Void) {

    binder = observable

    observable.bind { _, value  in
      DispatchQueue.main.async {
        handler(value)
      }
    }
  }

  func notifyValueChanged() {
    if let binder = binder, binder.value != observingValue {
      binder.value = observingValue
    }
  }

  func bind(to observable: Observable<BindingType>) {

    (self as? UIControl)?.addTarget(Selector, action: Selector { [weak self] in self?.notifyValueChanged() }, for: [.editingChanged, .valueChanged])

    if let value = observable.value {
      self.observingValue = value
    }

    observe(for: observable) { value in
      self.observingValue = value
    }
  }

}
