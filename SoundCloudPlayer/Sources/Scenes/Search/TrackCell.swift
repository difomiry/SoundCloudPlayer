
import UIKit
import RxSwift

class TrackCell: UITableViewCell {

  @IBOutlet private var artworkImageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var durationLabel: UILabel!
  @IBOutlet private var usernameLabel: UILabel!

  private var disposeBag = DisposeBag()

  override func prepareForReuse() {
    disposeBag = DisposeBag()
    artworkImageView.alpha = 0
  }

  func bind(to viewModel: TrackCellViewModelType) {

    viewModel.output.title
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.output.username
      .bind(to: usernameLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.output.duration
      .map { duration -> String in String(format: "%02i:%02i", ((duration / 1000) / 60 % 60), (duration / 1000) % 60) }
      .bind(to: durationLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.output.artwork
      .do(onNext: { _ in UIView.animate(withDuration: 0.1) { [weak self] in self?.artworkImageView.alpha = 1 } })
      .bind(to: artworkImageView.rx.image)
      .disposed(by: disposeBag)
  }

}
