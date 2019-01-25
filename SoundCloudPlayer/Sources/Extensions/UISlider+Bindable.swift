
import UIKit

extension UISlider: Bindable {

  typealias BindingType = Float

  var observingValue: BindingType? {
    get {
      return value
    }
    set {
      value = newValue ?? 0
    }
  }

}
