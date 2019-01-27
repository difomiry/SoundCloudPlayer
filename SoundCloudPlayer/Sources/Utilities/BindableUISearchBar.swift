
import UIKit

class BindableUISearchBar: UISearchBar, Bindable {

  typealias BindingType = String

  var observingValue: BindingType? {
    get {
      return text
    }
    set {
      text = newValue
    }
  }

  func bind(to observable: Observable<BindingType>) {

    delegate = self

    if let value = observable.value {
      observingValue = value
    }

    observe(for: observable) { value in
      self.observingValue = value
    }
  }

}
