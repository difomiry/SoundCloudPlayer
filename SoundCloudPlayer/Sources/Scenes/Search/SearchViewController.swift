
import UIKit
import RxSwift
import RxCocoa

final class SearchViewController: ViewController<SearchViewModel, SearchRouter> {

  // MARK: - IBOutlets

  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var tableView: UITableView!

  private var startTypingView: SearchMessageView!
  private var nothingFoundView: SearchMessageView!

  override func setupViews() {

    navigationController?.isNavigationBarHidden = true

    tableView.separatorInset = .zero
    tableView.rowHeight = 70
    tableView.tableFooterView = UIView()

    tableView.register(SearchCell.self)

    let messageFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70)

    startTypingView = SearchMessageView.make(frame: messageFrame, with: "Start typing to search…")
    nothingFoundView = SearchMessageView.make(frame: messageFrame, with: "Sorry, we found nothing :(")
  }

  override func setupBindings() {

    let observableQuery = searchBar.rx.text.orEmpty.asDriver()
      .throttle(0.5)
      .distinctUntilChanged()

    let output = viewModel.fetchOutput(.init(query: observableQuery))

    Driver.combineLatest(observableQuery, output.isLoading, output.tracks)
      .drive(onNext: { query, isLoading, tracks in
        switch (query.isEmpty, isLoading, tracks.isEmpty) {
        case (true, _, _):
          self.tableView.tableFooterView = self.startTypingView
        case (false, false, true):
          self.tableView.tableFooterView = self.nothingFoundView
        default:
          self.tableView.tableFooterView = UIView()
        }
      })
      .disposed(by: disposeBag)

    output.tracks
      .drive(tableView.rx.items(cellIdentifier: "SearchCell", cellType: SearchCell.self)) { (index, track: SearchCellViewModel, cell) in
        cell.bind(to: track)
      }
      .disposed(by: disposeBag)

    keyboardHeight
      .map { height -> UIEdgeInsets in .init(top: 0, left: 0, bottom: height, right: 0) }
      .drive(onNext: { [weak self] insets in
        self?.tableView.contentInset = insets
        self?.tableView.scrollIndicatorInsets = insets
      })
      .disposed(by: disposeBag)
  }

}
