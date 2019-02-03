
import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {

  // MARK: - IBOutlets

  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var tableView: UITableView!

  // MARK: - Properties

  private lazy var router = SearchRouter(viewController: self)

  private let viewModel: SearchViewModelType
  private let disposeBag = DisposeBag()

  // MARK: - Init

  init(viewModel: SearchViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: "SearchViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isNavigationBarHidden = true

    tableView.separatorInset = .zero
    tableView.rowHeight = 60
    tableView.tableFooterView = UIView()

    tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")

    searchBar.rx.text.orEmpty
      .bind(to: viewModel.input.query)
      .disposed(by: disposeBag)

    viewModel.output.tracks
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "SearchCell", cellType: SearchCell.self)) { (index, track: SearchCellViewModelType, cell) in
        cell.bind(to: track)
      }
      .disposed(by: disposeBag)

    keyboardHeight
      .map { height -> UIEdgeInsets in .init(top: 0, left: 0, bottom: height, right: 0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] insets in
        self?.tableView.contentInset = insets
        self?.tableView.scrollIndicatorInsets = insets
      })
      .disposed(by: disposeBag)
  }

}
