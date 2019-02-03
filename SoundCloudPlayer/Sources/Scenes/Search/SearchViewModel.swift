
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

  // MARK: - Properties

  private let soundCloudService: SoundCloudServiceType

  // MARK: - Init

  init(soundCloudService: SoundCloudServiceType = ServiceLocator.shared.soundCloudService) {
    self.soundCloudService = soundCloudService
  }

  // MARK: - ViewModelType

  func transform(input: Input) -> Output {
    return Output(tracks: input.query
      .throttle(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .flatMapLatest { query -> Observable<[Track]> in
        if query.isEmpty { return .just([]) }
        return self.soundCloudService.search(query: query).catchErrorJustReturn([])
      }
      .map { tracks in tracks.map { track in SearchCellViewModel(track: track) } })
  }

}
