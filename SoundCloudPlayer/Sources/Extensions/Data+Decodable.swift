
import Foundation

extension Data {

  func map<D: Decodable>(type: D.Type, using decoder: JSONDecoder = .init()) throws -> D {
    return try decoder.decode(type, from: self)
  }

}
