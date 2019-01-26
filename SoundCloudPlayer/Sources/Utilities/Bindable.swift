
protocol Bindable: NSObjectProtocol {

  associatedtype BindingType: Equatable

  var observingValue: BindingType? { get set }

  func bind(to observable: Observable<BindingType>)

}
