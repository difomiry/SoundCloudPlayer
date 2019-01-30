
import UIKit
import RxSwift

protocol TrackViewModelType {
  var id: Int { get }
  var title: String { get }
  var username: String { get }
  var duration: Int { get }
  var artwork: Observable<UIImage> { get }
}

final class TrackViewModel {

  private(set) var id: Int
  private(set) var title: String
  private(set) var username: String
  private(set) var duration: Int
  private(set) var artwork: Observable<UIImage>

  init(_ track: Track, soundCloudService: SoundCloudServiceType) {
    id = track.id
    title = track.title
    username = track.user.username
    duration = track.duration
    artwork = soundCloudService.fetchArtwork(path: track.artwork)
  }

}
