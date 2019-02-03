
import UIKit
import RxSwift

final class SearchCellViewModel: ViewModelType {

  // MARK: - ViewModelType

  struct Input {}

  struct Output {

    /// Emits the track title.
    let title: Observable<String>

    /// Emits the track author.
    let username: Observable<String>

    /// Emits the track duration.
    let duration: Observable<Int>

    /// Emits the track artwork.
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

  func transform(input: Input) -> Output {
    return Output(
      title: Observable.just(track.title),
      username: Observable.just(track.user.username),
      duration: Observable.just(track.duration),
      artwork: soundCloudService.fetchArtwork(path: track.artwork))
  }

}
