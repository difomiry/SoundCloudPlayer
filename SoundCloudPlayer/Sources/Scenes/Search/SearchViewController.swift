
import UIKit

final class SearchViewController: UIViewController {

  init() {
    super.init(nibName: "SearchViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isNavigationBarHidden = true
  }

}
