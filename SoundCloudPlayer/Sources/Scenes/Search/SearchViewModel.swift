
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {

  // MARK: - ViewModelType

  struct Input {
    let query: Driver<String>
  }

  struct Output {
    let isLoading: Driver<Bool>
    let tracks: Driver<[SearchCellViewModel]>
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
    let isLoading = _isLoading.asDriver(onErrorJustReturn: false)

    let tracks = input.query
      .flatMapLatest { query -> Driver<[Track]> in
        if query.isEmpty { return .just([]) }
        _isLoading.onNext(true)
        return self.soundCloudService.search(query: query)
          .do(onNext: { _ in _isLoading.onNext(false) })
          .asDriver(onErrorJustReturn: [])
      }
      .map { tracks in tracks.map { track in SearchCellViewModel(track: track) } }

    return Output(isLoading: isLoading, tracks: tracks)
  }

}
