
import UIKit

protocol RouterType: class {

  associatedtype Route

  init(viewController: UIViewController)

  func navigate(to route: Route)

}

class Router: RouterType {

  enum Route {}

  let viewController: UIViewController

  required init(viewController: UIViewController) {
    self.viewController = viewController
  }

  func navigate(to route: Route) {
    fatalError("`navigate` method should be implemented.")
  }

}
