
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
      .bind(to: tableView.rx.items(cellIdentifier: "TrackCell", cellType: TrackCell.self)) { (index, track: TrackViewModel, cell) in
        cell.bind(track)
      }
      .disposed(by: disposeBag)
  }

}
