
import UIKit
import RxSwift
import RxCocoa

final class TrackViewController: UIViewController {

  @IBOutlet var artworkImageView: UIImageView!
  @IBOutlet var sliderView: UISlider!
  @IBOutlet var currentDurationLabel: UILabel!
  @IBOutlet var durationLabel: UILabel!

  @IBOutlet var rewindButton: UIImageView!
  @IBOutlet var playButton: UIImageView!
  @IBOutlet var fastForwardButton: UIImageView!

  let viewModel: TrackViewModel
  let disposeBag = DisposeBag()

  init(viewModel: TrackViewModel) {
    self.viewModel = viewModel
    super.init(nibName: "TrackViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isNavigationBarHidden = false

    let gesture = UITapGestureRecognizer()
    playButton.addGestureRecognizer(gesture)

    let output = viewModel.fetchOutput(TrackViewModel.Input(playOrPause: gesture.rx.event.asDriver().map { _ in }))

    output.track
      .map { track in track.title }
      .drive(rx.title)
      .disposed(by: disposeBag)

    output.track
      .map { track in track.duration }
      .do(onNext: { [weak self] duration in self?.sliderView.maximumValue = Float(duration / 1000) })
      .map { duration in String(milliseconds: duration) }
      .drive(durationLabel.rx.text)
      .disposed(by: disposeBag)

    output.time
      .map { duration in Int(duration) }
      .map { duration in String(seconds: duration) }
      .drive(currentDurationLabel.rx.text)
      .disposed(by: disposeBag)

    output.artwork
      .drive(artworkImageView.rx.image)
      .disposed(by: disposeBag)

    output.state
      .filter { $0 == .played }
      .map { _ in UIImage(named: "Pause") }
      .drive(playButton.rx.image)
      .disposed(by: disposeBag)

    output.state
      .filter { $0 == .paused }
      .map { _ in UIImage(named: "Play") }
      .drive(playButton.rx.image)
      .disposed(by: disposeBag)

    output.time
      .drive(sliderView.rx.value)
      .disposed(by: disposeBag)
  }

}
