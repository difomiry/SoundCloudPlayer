
import UIKit
import RxSwift

protocol CellType: class {

  associatedtype ViewModel

  /// The disposeBag for children.
  var disposeBag: DisposeBag { get }

  /// Binds the viewModel to this cell.
  func bind(to viewModel: ViewModel)

}

class Cell<ViewModel: ViewModelType>: UITableViewCell, CellType, NibReusable {

  /// The disposeBag for children.
  private(set) var disposeBag = DisposeBag()

  override func prepareForReuse() {
    super.prepareForReuse()

    disposeBag = DisposeBag()
  }

  /// Binds the viewModel to this cell.
  func bind(to viewModel: ViewModel) {
    fatalError("`bind` method should be implemented.")
  }

}
