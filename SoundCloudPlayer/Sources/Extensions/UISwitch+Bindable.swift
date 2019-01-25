
import UIKit

extension UISwitch: Bindable {

  typealias BindingType = Bool

  var observingValue: BindingType? {
    get {
      return isOn
    }
    set {
      isOn = newValue ?? false
    }
  }

}
