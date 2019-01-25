
import UIKit

extension UISearchBar: Bindable {

  typealias BindingType = String

  var observingValue: BindingType? {
    get {
      return text
    }
    set {
      text = newValue
    }
  }

}
