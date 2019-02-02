
import RxSwift

protocol SearchViewModelInputType {

  /// Call when search query is updated.
  var query: AnyObserver<String> { get }

}

protocol SearchViewModelOutputType {

  /// Emits the search results.
  var tracks: Observable<[SearchCellViewModelType]> { get }

}

protocol SearchViewModelType {
  var input: SearchViewModelInputType { get }
  var output: SearchViewModelOutputType { get }
}

final class SearchViewModel: SearchViewModelType, SearchViewModelInputType, SearchViewModelOutputType {

  // MARK: - Input & Output

  var input: SearchViewModelInputType {
    return self
  }

  var output: SearchViewModelOutputType {
    return self
  }

  // MARK: - Inputs

  /// Call when search query is updated.
  let query: AnyObserver<String>

  // MARK: - Outputs

  /// Emits the search results.
  let tracks: Observable<[SearchCellViewModelType]>

  // MARK: - Init

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
      .map { tracks in tracks.map { track -> SearchCellViewModelType in SearchCellViewModel(track, artwork: soundCloudService.fetchArtwork(path: track.artwork)) } }
  }

}
