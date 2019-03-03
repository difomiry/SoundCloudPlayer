
import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class TrackViewModel: ViewModelType {

  struct Input {
    let playOrPause: Driver<Void>
  }

  struct Output {
    let track: Driver<Track>
    let artwork: Driver<UIImage>
    let state: Driver<State>
    let time: Driver<Float>
  }

  enum State {
    case idle
    case played
    case paused
  }

  let track: Track
  private let soundCloudService: SoundCloudServiceType

  let disposeBag = DisposeBag()

  let player = AVPlayer()

  private var isPlayed = false
  private var isPaused = false

  init(track: Track, soundCloudService: SoundCloudServiceType) {
    self.track = track
    self.soundCloudService = soundCloudService
  }

  func fetchOutput(_ input: Input?) -> Output {

    guard let input = input else { fatalError() }

    let _state = BehaviorRelay<State>(value: .idle)

    let observableState = _state.asDriver(onErrorJustReturn: .idle)

    let time = player.rx.periodicTimeObserver(interval: CMTime(seconds: 1, preferredTimescale: 1))
      .asDriver(onErrorJustReturn: CMTime(seconds: 1, preferredTimescale: 1))
      .map { Int64($0.value) / Int64($0.timescale) }
      .map { Float(exactly: $0) ?? 2 }

    Driver.combineLatest(input.playOrPause.withLatestFrom(observableState), soundCloudService.fetchStreamURL(id: track.id).asDriver(onErrorJustReturn: URL(string: "a")!))
      .drive(onNext: { [weak self] state, url in
        guard let `self` = self else { return }
        switch state {
        case .idle:
          do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            let item = AVPlayerItem(url: url)
            self.player.replaceCurrentItem(with: item)
            self.player.play()
          } catch {}
        case .played:
          self.player.pause()
        case .paused:
          self.player.play()
        }
      })
      .disposed(by: disposeBag)

    input.playOrPause.withLatestFrom(observableState)
      .map { s -> State in
        switch s {
        case .idle:
          return .played
        case .played:
          return .paused
        case .paused:
          return .played
        }
      }
      .drive(_state)
      .disposed(by: disposeBag)

    return Output(
      track: Driver.just(track),
      artwork: soundCloudService.fetchArtwork(path: track.artwork, with: .t500x500).asDriver(onErrorJustReturn: UIImage(named: "Artwork")!),
      state: _state.asDriver(onErrorJustReturn: .idle),
      time: time
    )
  }

}

