import RxSwift

protocol SearchViewModelType {

  /// Call to update search query.
  var query: AnyObserver<String> { get }

  /// Emits an array of fetched tracks.
  var tracks: Observable<[Track]> { get }

}

final class SearchViewModel: SearchViewModelType {

  /// Call to update search query.
  private(set) var query: AnyObserver<String>

  /// Emits an array of fetched tracks.
  private(set) var tracks: Observable<[Track]>

  init(soundCloudService: SoundCloudServiceType) {

    let _query = BehaviorSubject<String>(value: "")
    query = _query.asObserver()

    tracks = _query.asObservable()
      .throttle(2.0, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { query in !query.isEmpty }
      .flatMapLatest { query in soundCloudService.search(query: query).catchErrorJustReturn([]) }
      .observeOn(MainScheduler.instance)
  }

}
