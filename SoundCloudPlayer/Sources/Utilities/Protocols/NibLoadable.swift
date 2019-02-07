
import UIKit

protocol NibLoadable: class {
  static var nib: UINib { get }
}

extension NibLoadable {

  static var nib: UINib {
    return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }

}
