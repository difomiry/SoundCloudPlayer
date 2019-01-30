
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

  func bind(to viewModel: TrackViewModel) {
    titleLabel.text = viewModel.title
    usernameLabel.text = viewModel.username
    durationLabel.text = String(format: "%02i:%02i", ((viewModel.duration / 1000) / 60 % 60), (viewModel.duration / 1000) % 60)

    viewModel
      .artwork
      .observeOn(MainScheduler.instance)
      .do(onNext: { _ in UIView.animate(withDuration: 0.1) { [weak self] in self?.artworkImageView.alpha = 1 } })
      .bind(to: artworkImageView.rx.image)
      .disposed(by: disposeBag)
  }

}
