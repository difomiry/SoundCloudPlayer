
import RxSwift

final class SearchViewModel: ViewModelType {

  // MARK: - ViewModelType

  struct Input {
    let query: Observable<String>
  }

  struct Output {
    let isLoading: Observable<Bool>
    let tracks: Observable<[SearchCellViewModel]>
  }

  // MARK: - Properties

  private let soundCloudService: SoundCloudServiceType

  // MARK: - Init

  init(soundCloudService: SoundCloudServiceType = ServiceLocator.shared.soundCloudService) {
    self.soundCloudService = soundCloudService
  }

  // MARK: - ViewModelType

  func fetchOutput(_ input: Input?) -> Output {

    guard let input = input else {
      fatalError("`input` should not be nil.")
    }

    let _isLoading = BehaviorSubject<Bool>(value: false)
    let isLoading = _isLoading.asObservable()

    let tracks = input.query
      .throttle(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .flatMapLatest { query -> Observable<[Track]> in
        if query.isEmpty { return .just([]) }
        _isLoading.onNext(true)
        return self.soundCloudService.search(query: query).catchErrorJustReturn([]).do(onNext: { _ in
          _isLoading.onNext(false)
        })
      }
      .map { tracks in tracks.map { track in SearchCellViewModel(track: track) } }

    return Output(isLoading: isLoading, tracks: tracks)
  }

}
