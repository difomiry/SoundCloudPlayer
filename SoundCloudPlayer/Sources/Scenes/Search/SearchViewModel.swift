
import RxSwift

final class SearchViewModel: ViewModelType {

  // MARK: - ViewModelType

  struct Input {

    /// Call when search query is updated.
    let query: Observable<String>

  }

  struct Output {

    /// Emits the search results.
    let tracks: Observable<[SearchCellViewModel]>

  }

  // MARK: - ViewModelType

  func transform(input: Input) -> Output {
    return Output(tracks: input.query
      .throttle(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .flatMapLatest { query -> Observable<[Track]> in
        if query.isEmpty { return .just([]) }
        return ServiceLocator.shared.soundCloudService.search(query: query).catchErrorJustReturn([])
      }
      .map { tracks in tracks.map(SearchCellViewModel.init) })
  }

}
