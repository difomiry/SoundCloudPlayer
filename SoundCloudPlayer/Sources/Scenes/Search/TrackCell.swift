
import UIKit

class TrackCell: UITableViewCell {

  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var durationLabel: UILabel!

  func setTitle(_ title: String) {
    titleLabel.text = title
  }

  func setDuration(_ duration: String) {
    durationLabel.text = duration
  }

}
