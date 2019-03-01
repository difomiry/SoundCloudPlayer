
import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: ViewController<SearchViewModel, SearchRouter> {

  // MARK: - IBOutlets

  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var tableView: UITableView!

  private var typingView: SearchMessageView!
  private var notFoundView: SearchMessageView!

  override func setupViews() {

    navigationController?.isNavigationBarHidden = true

    tableView.separatorInset = .zero
    tableView.rowHeight = 70
    tableView.tableFooterView = UIView()

    tableView.register(SearchCell.self)

    typingView = SearchMessageView.instantiate()
    typingView.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: 70)
    typingView.configure(with: "Start typing to search…")

    notFoundView = SearchMessageView.instantiate()
    notFoundView.frame = .init(x: 0, y: 0, width: tableView.frame.width, height: 70)
    notFoundView.configure(with: "Sorry, we found nothing :(")
  }

  override func setupBindings() {

    let observableQuery = searchBar.rx.text.orEmpty.asObservable()

    let output = viewModel.fetchOutput(.init(query: observableQuery))

    Observable.combineLatest(observableQuery, output.isLoading, output.tracks)
      .subscribe(onNext: { query, isLoading, tracks in
        switch (query.isEmpty, isLoading, tracks.isEmpty) {
        case (true, _, _):
          self.tableView.tableFooterView = self.typingView
        case (false, false, true):
          self.tableView.tableFooterView = self.notFoundView
        default:
          self.tableView.tableFooterView = UIView()
        }
      })
      .disposed(by: disposeBag)

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
