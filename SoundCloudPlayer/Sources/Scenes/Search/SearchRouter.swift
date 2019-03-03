
import UIKit

final class SearchRouter: Router<SearchRouter.Route> {

  enum Route {
    case track(Track, SoundCloudServiceType)
  }

  override func navigate(to route: Route) {
    switch route {
    case let .track(track, soundCloudService):
      viewController.navigationController?.pushViewController(TrackViewController(viewModel: TrackViewModel(track: track, soundCloudService: soundCloudService)), animated: true)
    }
  }

}
