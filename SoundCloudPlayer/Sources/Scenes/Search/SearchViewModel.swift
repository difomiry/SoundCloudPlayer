
import RxSwift

final class SearchViewModel: ViewModel<SearchViewModel.Input, SearchViewModel.Output> {

  // MARK: - ViewModelType

  struct Input {
    let query: Observable<String>
  }

  struct Output {
    let tracks: Observable<[SearchCellViewModel]>
  }

  // MARK: - Properties

  private let soundCloudService: SoundCloudServiceType

  // MARK: - Init

  init(soundCloudService: SoundCloudServiceType = ServiceLocator.shared.soundCloudService) {
    self.soundCloudService = soundCloudService
  }

  // MARK: - ViewModelType

  override func fetchOutput(_ input: Input?) -> Output {

    guard let input = input else {
      fatalError("`input` should not be nil.")
    }

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
