
import UIKit
import RxSwift

class AppCoordinator: Coordinator<Void> {

  private let window: UIWindow
  private let disposeBag = DisposeBag()

  init(window: UIWindow) {
    self.window = window
  }

  override func start() -> Observable<Void> {
    return coordinate(to: SearchCoordinator(window: window))
  }

}
