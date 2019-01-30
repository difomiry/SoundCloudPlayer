
import Foundation

protocol HTTPTargetType {
  var baseURL: URL { get }
  var path: String? { get }
  var method: HTTPMethod { get }
  var headers: [String: String]? { get }
  var task: HTTPTargetTask? { get }
}

extension HTTPTargetType {

  var path: String? {
    return nil
  }

  var method: HTTPMethod {
    return .get
  }

  var headers: [String: String]? {
    return nil
  }

  var task: HTTPTargetTask? {
    return nil
  }

}
