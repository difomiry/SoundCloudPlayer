
import UIKit

final class SearchRouter: Router<SearchRouter.Route> {

  enum Route {
    case track(SearchCellViewModel)
  }

  override func navigate(to route: Route) {
    switch route {
    case let .track(svm):
      let viewModel = TrackViewModel(viewModel: svm)
      viewController.navigationController?.pushViewController(TrackViewController(viewModel: viewModel), animated: true)
    }
  }

}
