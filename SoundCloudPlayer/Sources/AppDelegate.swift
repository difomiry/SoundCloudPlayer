
import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow()

    let viewModel = SearchViewModel()
    let viewController = SearchViewController(viewModel: viewModel)
    let navigationController = UINavigationController(rootViewController: viewController)

    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return true
  }

}
