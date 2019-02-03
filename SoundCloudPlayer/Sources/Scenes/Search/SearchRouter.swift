
import UIKit

final class SearchRouter: RouterType {

  enum Route {}

  private let viewController: UIViewController

  init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func navigate(to route: Route) {
    switch route {}
  }

}
