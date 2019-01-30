import RxSwift

protocol SearchViewModelType {

  /// Call to update search query.
  var query: AnyObserver<String> { get }

  /// Emits an array of fetched tracks.
  var tracks: Observable<[TrackViewModel]> { get }

}

final class SearchViewModel: SearchViewModelType {

  /// Call to update search query.
  private(set) var query: AnyObserver<String>

  /// Emits an array of fetched tracks.
  private(set) var tracks: Observable<[TrackViewModel]>

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
      .observeOn(MainScheduler.instance)
  }

}
