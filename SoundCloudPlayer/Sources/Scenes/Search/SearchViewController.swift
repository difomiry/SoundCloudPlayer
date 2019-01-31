
import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {

  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var tableView: UITableView!

  private let viewModel: SearchViewModelType

  private let disposeBag = DisposeBag()

  init(viewModel: SearchViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: "SearchViewController", bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isNavigationBarHidden = true

    tableView.separatorInset = .zero
    tableView.rowHeight = 60
    tableView.tableFooterView = UIView()

    tableView.register(UINib(nibName: "TrackCell", bundle: nil), forCellReuseIdentifier: "TrackCell")

    searchBar.rx.text.orEmpty
      .bind(to: viewModel.query)
      .disposed(by: disposeBag)

    viewModel.tracks
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "TrackCell", cellType: TrackCell.self)) { (index, track: TrackViewModel, cell) in
        cell.bind(to: track)
      }
      .disposed(by: disposeBag)

    viewModel.keyboardHeight
      .map { height -> UIEdgeInsets in .init(top: 0, left: 0, bottom: height, right: 0) }
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] insets in
        self?.tableView.contentInset = insets
        self?.tableView.scrollIndicatorInsets = insets
      })
      .disposed(by: disposeBag)
  }

}
