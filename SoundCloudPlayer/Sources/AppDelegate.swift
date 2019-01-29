
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let provider: ServiceProviderType = ServiceProvider()

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = UINavigationController(rootViewController: SearchViewController(viewModel: SearchViewModel(soundCloudService: provider.soundCloudService)))
    window?.makeKeyAndVisible()

    return true
  }

}
