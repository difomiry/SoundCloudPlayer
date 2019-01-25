
import UIKit

extension UISegmentedControl: Bindable {

  typealias BindingType = Int

  var observingValue: BindingType? {
    get {
      return selectedSegmentIndex
    }
    set {
      selectedSegmentIndex = newValue ?? 0
    }
  }

}
