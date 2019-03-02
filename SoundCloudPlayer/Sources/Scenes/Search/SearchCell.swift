
import UIKit
import RxSwift

final class SearchCell: Cell<SearchCellViewModel> {

  // MARK: - IBOutlets

  @IBOutlet private var artworkImageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var durationLabel: UILabel!
  @IBOutlet private var usernameLabel: UILabel!

  // MARK: - UITableViewCell

  override func prepareForReuse() {
    super.prepareForReuse()

    artworkImageView.alpha = 0
  }

  // MARK: - Binding

  override func bind(to viewModel: SearchCellViewModel) {

    let output = viewModel.fetchOutput()

    output.track
      .map { track in track.title }
      .drive(titleLabel.rx.text)
      .disposed(by: disposeBag)

    output.track
      .map { track in track.user.username }
      .drive(usernameLabel.rx.text)
      .disposed(by: disposeBag)

    output.track
      .map { track in track.duration }
      .map { duration in String(milliseconds: duration) }
      .drive(durationLabel.rx.text)
      .disposed(by: disposeBag)

    output.artwork
      .do(onNext: { _ in UIView.animate(withDuration: 0.1) { [weak self] in self?.artworkImageView.alpha = 1 } })
      .drive(artworkImageView.rx.image)
      .disposed(by: disposeBag)
  }

}
