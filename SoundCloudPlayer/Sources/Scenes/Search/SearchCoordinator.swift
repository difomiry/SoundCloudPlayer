
import UIKit
import RxSwift

class SearchCoordinator: Coordinator<Void> {

  private let window: UIWindow

  init(window: UIWindow) {
    self.window = window
  }

  override func start() -> Observable<Void> {

    let provider = ServiceProvider()

    let viewModel = SearchViewModel(soundCloudService: provider.soundCloudService)
    let viewController = SearchViewController(viewModel: viewModel)
    let navigationController = UINavigationController(rootViewController: viewController)

    window.rootViewController = navigationController
    window.makeKeyAndVisible()

    return Observable.never()
  }

}
