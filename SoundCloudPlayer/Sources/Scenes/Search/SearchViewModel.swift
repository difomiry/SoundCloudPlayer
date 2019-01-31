
import UIKit
import RxSwift

protocol SearchViewModelType {

  /// Call to update search query.
  var query: AnyObserver<String> { get }

  /// Emits an array of fetched tracks.
  var tracks: Observable<[TrackViewModel]> { get }

  /// Emits a keyboard height.
  var keyboardHeight: Observable<CGFloat> { get }

}

final class SearchViewModel: SearchViewModelType {

  /// Call to update search query.
  let query: AnyObserver<String>

  /// Emits an array of fetched tracks.
  let tracks: Observable<[TrackViewModel]>

  /// Emits a keyboard height.
  let keyboardHeight: Observable<CGFloat>

  init(soundCloudService: SoundCloudServiceType) {

    let _query = BehaviorSubject<String>(value: "")
    query = _query.asObserver()

    tracks = _query.asObservable()
      .throttle(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .flatMapLatest { query -> Observable<[Track]> in
        if query.isEmpty { return .just([]) }
        return soundCloudService.search(query: query).catchErrorJustReturn([])
      }
      .map { tracks in tracks.map { track in TrackViewModel(track, soundCloudService: soundCloudService) } }

    let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .map { notification -> CGFloat in (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }

    let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .map { _ -> CGFloat in 0 }

    keyboardHeight = Observable.from([keyboardWillShow, keyboardWillHide]).merge()
  }

}
