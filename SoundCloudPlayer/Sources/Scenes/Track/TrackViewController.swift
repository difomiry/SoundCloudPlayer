
import UIKit
import RxSwift

final class TrackViewModel: ViewModelType {

  struct Input {}

  struct Output {

    let track: Observable<Track>

    let artwork: Observable<UIImage>

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
//
//    let output = viewModel.transform(.init())
//
//    sliderView.minimumValue = 0
//
//    output.track
//      .map { track in track.title }
//      .bind(to: rx.title)
//      .disposed(by: disposeBag)
//
//    output.track
//      .map { track in track.title }
//      .bind(to: titleLabel.rx.text)
//      .disposed(by: disposeBag)
//
//    output.track
//      .map { track in track.description }
//      .bind(to: descriptionLabel.rx.text)
//      .disposed(by: disposeBag)
//
//    output.track
//      .map { track in track.duration }
//      .do(onNext: { duration in self.sliderView.maximumValue = Float(duration) })
//      .map { duration in String(milliseconds: duration) }
//      .bind(to: durationLabel.rx.text)
//      .disposed(by: disposeBag)
//
//    sliderView.rx.value.asObservable()
//      .map { duration in Int(duration) }
//      .map { duration in String(milliseconds: duration) }
//      .bind(to: currentDurationLabel.rx.text)
//      .disposed(by: disposeBag)
//
//    output.artwork
//      .bind(to: artworkImageView.rx.image)
//      .disposed(by: disposeBag)
  }

}
