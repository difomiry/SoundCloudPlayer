
import Foundation

protocol HTTPTargetType {
  var baseURL: URL { get }
  var path: String? { get }
  var method: HTTPMethod { get }
  var parameters: [String: String]? { get }
  var body: Data? { get }
  var headers: [String: String]? { get }
}

extension HTTPTargetType {

  var path: String? {
    return nil
  }

  var method: HTTPMethod {
    return .get
  }

  var parameters: [String: String]? {
    return nil
  }

  var body: Data? {
    return nil
  }

  var headers: [String: String]? {
    return nil
  }

}
