
import Foundation

enum HTTPTargetTask {
  case url(parameters: [String: String])
  case body(data: Data)
}
