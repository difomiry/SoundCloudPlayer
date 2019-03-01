
import UIKit

extension UIView {
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.masksToBounds = newValue != 0
      layer.cornerRadius = newValue
    }
  }
  
}
