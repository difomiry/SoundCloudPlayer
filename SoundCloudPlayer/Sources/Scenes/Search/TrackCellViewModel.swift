
import UIKit
import RxSwift

protocol TrackCellViewModelInputType {}

protocol TrackCellViewModelOutputType {

  /// Emits the track title.
  var title: Observable<String> { get }

  /// Emits the track author.
  var username: Observable<String> { get }

  /// Emits the track duration.
  var duration: Observable<Int> { get }

  /// Emits the track artwork.
  var artwork: Observable<UIImage> { get }

}

protocol TrackCellViewModelType {
  var input: TrackCellViewModelInputType { get }
  var output: TrackCellViewModelOutputType { get }
}

final class TrackCellViewModel: TrackCellViewModelType, TrackCellViewModelInputType, TrackCellViewModelOutputType {

  // MARK: - Input & Output

  var input: TrackCellViewModelInputType {
    return self
  }

  var output: TrackCellViewModelOutputType {
    return self
  }

  // MARK: - Outputs

  /// Emits the track title.
  let title: Observable<String>

  /// Emits the track author.
  let username: Observable<String>

  /// Emits the track duration.
  let duration: Observable<Int>

  /// Emits the track artwork.
  let artwork: Observable<UIImage>

  init(_ track: Track, soundCloudService: SoundCloudServiceType) {
    title = Observable.just(track.title)
    username = Observable.just(track.user.username)
    duration = Observable.just(track.duration)
    artwork = soundCloudService.fetchArtwork(path: track.artwork)
  }

}
