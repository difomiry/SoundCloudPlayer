
import UIKit

extension BindableUISearchBar: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    notifyValueChanged()
  }

}
