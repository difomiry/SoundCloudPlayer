
import Foundation

protocol Bindable: NSObjectProtocol {

  associatedtype BindingType: Equatable

  var observingValue: BindingType? { get set }

  func bind(with observable: Observable<BindingType>)

}
