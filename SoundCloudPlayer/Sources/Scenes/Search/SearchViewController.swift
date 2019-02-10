
import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: ViewController<SearchViewModel, SearchRouter> {

  // MARK: - IBOutlets

  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var tableView: UITableView!

  override func setupViews() {

    navigationController?.isNavigationBarHidden = true

    tableView.separatorInset = .zero
    tableView.rowHeight = 60
    tableView.tableFooterView = UIView()

    tableView.register(SearchCell.self)
  }

  override func setupBindings() {

    let output = viewModel.fetchOutput(.init(query: searchBar.rx.text.orEmpty.asObservable()))

    output.tracks
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "SearchCell", cellType: SearchCell.self)) { (index, track: SearchCellViewModel, cell) in
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
