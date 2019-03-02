
import UIKit

final class SearchMessageView: UIView, NibLoadable {

  @IBOutlet private var messageLabel: UILabel!

  static func make(frame: CGRect, with message: String) -> SearchMessageView {
    let view = SearchMessageView.instantiate()
    view.frame = frame
    view.messageLabel.text = message
    return view
  }

}
