
import UIKit
import RxSwift
import RxCocoa

final class TrackViewModel: ViewModelType {

  struct Input {}

  struct Output {
    let track: Driver<Track>
    let artwork: Driver<UIImage>
  }

  let viewModel: SearchCellViewModel

  init(viewModel: SearchCellViewModel) {
    self.viewModel = viewModel
  }

  func fetchOutput(_ input: Input? = nil) -> Output {

    let output = viewModel.fetchOutput()

    return Output(
      track: output.track,
      artwork: output.artwork
    )
  }

}

final class TrackViewController: UIViewController {

  @IBOutlet var artworkImageView: UIImageView!
  @IBOutlet var sliderView: UISlider!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var currentDurationLabel: UILabel!
  @IBOutlet var durationLabel: UILabel!


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

    let output = viewModel.fetchOutput()

    sliderView.minimumValue = 0

    output.track
      .map { track in track.title }
      .drive(rx.title)
      .disposed(by: disposeBag)

    output.track
      .map { track in track.title }
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)

    output.track
      .map { track in track.description }
      .drive(descriptionLabel.rx.text)
      .disposed(by: disposeBag)

    output.track
      .map { track in track.duration }
      .do(onNext: { duration in self.sliderView.maximumValue = Float(duration) })
      .map { duration in String(milliseconds: duration) }
      .drive(durationLabel.rx.text)
      .disposed(by: disposeBag)

    sliderView.rx.value.asDriver()
      .map { duration in Int(duration) }
      .map { duration in String(milliseconds: duration) }
      .drive(currentDurationLabel.rx.text)
      .disposed(by: disposeBag)

    output.artwork
      .drive(artworkImageView.rx.image)
      .disposed(by: disposeBag)
  }

}
