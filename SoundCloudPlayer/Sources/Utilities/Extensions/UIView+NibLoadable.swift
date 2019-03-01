
import UIKit

extension NibLoadable where Self: UIView  {
  
  static func instantiate() -> Self {
    guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
      fatalError()
    }
    return view
  }
  
}
