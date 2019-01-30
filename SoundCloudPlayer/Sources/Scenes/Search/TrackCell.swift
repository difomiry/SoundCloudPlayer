
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

  func bind(_ viewModel: TrackViewModel) {
    setTitle(viewModel.title)
    setUsername(viewModel.username)
    setDuration(String(format: "%02i:%02i", ((viewModel.duration / 1000) / 60 % 60), (viewModel.duration / 1000) % 60))

    viewModel
      .artwork
      .observeOn(MainScheduler.instance)
      .do(onNext: { _ in UIView.animate(withDuration: 0.1) { [weak self] in self?.artworkImageView.alpha = 1 } })
      .bind(to: artworkImageView.rx.image)
      .disposed(by: disposeBag)
  }

  func setTitle(_ title: String) {
    titleLabel.text = title
  }

  func setDuration(_ duration: String) {
    durationLabel.text = duration
  }

  func setUsername(_ username: String) {
    usernameLabel.text = username
  }

}
