
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

extension UISearchBar: UISearchBarDelegate {

  public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    valueChanged()
  }

}
