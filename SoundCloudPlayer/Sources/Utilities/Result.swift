
import Foundation

enum Result<ValueType> {
  case success(ValueType)
  case failure(Error)
}

extension Result {

  var value: ValueType? {
    switch self {
    case let .success(value):
      return value
    case .failure:
      return nil
    }
  }

  var error: Error? {
    switch self {
    case .success:
      return nil
    case let .failure(error):
      return error
    }
  }

  init(_ value: ValueType) {
    self = .success(value)
  }

  init(_ error: Error) {
    self = .failure(error)
  }

}
