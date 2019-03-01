
import UIKit

final class SearchMessageView: UIView, NibLoadable {

  @IBOutlet var messageLabel: UILabel!

  func configure(with message: String) {
    messageLabel.text = message
  }

}
