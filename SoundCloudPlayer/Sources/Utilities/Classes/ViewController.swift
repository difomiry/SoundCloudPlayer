
import UIKit
import RxSwift

protocol ViewControllerType: class {

  associatedtype ViewModel
  associatedtype Router

  /// The viewModel for children.
  var viewModel: ViewModel { get }

  /// The router for children.
  var router: Router { get }

  /// The disposeBag for children.
  var disposeBag: DisposeBag { get }

  /// Initializes an instance.
  init(viewModel: ViewModel)

  /// Sets up the views.
  func setupViews()

  /// Sets up the bindings.
  func setupBindings()

}

class ViewController<ViewModel: ViewModelType, Router: RouterType>: UIViewController, ViewControllerType {

  /// The viewModel for children.
  let viewModel: ViewModel

  /// The router for children.
  private(set) lazy var router: Router = .init(viewController: self)

  /// The disposeBag for children.
  let disposeBag = DisposeBag()

  /// Initializes an instance.
  required init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupBindings()
  }

  /// Sets up the views.
  func setupViews() {}

  /// Sets up the bindings.
  func setupBindings() {}

}
