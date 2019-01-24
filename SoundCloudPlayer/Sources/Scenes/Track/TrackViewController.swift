
import UIKit

final class TrackViewController: UIViewController {

  init() {
    super.init(nibName: "TrackViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isNavigationBarHidden = false
  }

}
