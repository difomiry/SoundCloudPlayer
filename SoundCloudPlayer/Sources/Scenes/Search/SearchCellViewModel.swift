
import UIKit
import RxSwift

protocol SearchCellViewModelInputType {}

protocol SearchCellViewModelOutputType {

  /// Emits the track title.
  var title: Observable<String> { get }

  /// Emits the track author.
  var username: Observable<String> { get }

  /// Emits the track duration.
  var duration: Observable<Int> { get }

  /// Emits the track artwork.
  var artwork: Observable<UIImage> { get }

}

protocol SearchCellViewModelType {
  var input: SearchCellViewModelInputType { get }
  var output: SearchCellViewModelOutputType { get }
}

final class SearchCellViewModel: SearchCellViewModelType, SearchCellViewModelInputType, SearchCellViewModelOutputType {

  // MARK: - Input & Output

  var input: SearchCellViewModelInputType {
    return self
  }

  var output: SearchCellViewModelOutputType {
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

  init(_ track: Track, artwork: Observable<UIImage>) {
    title = Observable.just(track.title)
    username = Observable.just(track.user.username)
    duration = Observable.just(track.duration)
    self.artwork = artwork
  }

}
