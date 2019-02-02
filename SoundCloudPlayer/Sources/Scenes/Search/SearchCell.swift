
import UIKit
import RxSwift

final class SearchCell: UITableViewCell {

  // MARK: - IBOutlets

  @IBOutlet private var artworkImageView: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var durationLabel: UILabel!
  @IBOutlet private var usernameLabel: UILabel!

  // MARK: - Properties

  private var disposeBag = DisposeBag()

  // MARK: - UITableViewCell

  override func prepareForReuse() {
    disposeBag = DisposeBag()
    artworkImageView.alpha = 0
  }

  // MARK: - Binding

  func bind(to viewModel: SearchCellViewModelType) {

    viewModel.output.title
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.output.username
      .bind(to: usernameLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.output.duration
      .map { duration in String(milliseconds: duration) }
      .bind(to: durationLabel.rx.text)
      .disposed(by: disposeBag)

    viewModel.output.artwork
      .do(onNext: { _ in UIView.animate(withDuration: 0.1) { [weak self] in self?.artworkImageView.alpha = 1 } })
      .bind(to: artworkImageView.rx.image)
      .disposed(by: disposeBag)
  }

}
