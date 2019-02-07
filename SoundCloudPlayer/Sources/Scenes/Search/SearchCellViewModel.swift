
import UIKit
import RxSwift

final class SearchCellViewModel: ViewModelType {

  // MARK: - ViewModelType

  struct Input {}

  struct Output {

    /// Emits the track.
    let track: Observable<Track>

    /// Emits the artwork of track.
    let artwork: Observable<UIImage>

  }

  // MARK: - Properties

  private let track: Track
  private let soundCloudService: SoundCloudServiceType

  // MARK: - Init

  init(track: Track, soundCloudService: SoundCloudServiceType = ServiceLocator.shared.soundCloudService) {
    self.track = track
    self.soundCloudService = soundCloudService
  }


  // MARK: - ViewModelType

  func transform(_ input: Input) -> Output {
    return Output(
      track: Observable.just(track),
      artwork: soundCloudService.fetchArtwork(path: track.artwork))
  }

}
