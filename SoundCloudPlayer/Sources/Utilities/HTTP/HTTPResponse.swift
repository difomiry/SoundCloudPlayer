
import Foundation

protocol HTTPResponseType {

  var data: Data { get }

  init(data: Data)

  func json<Value: Decodable>(type: Value.Type, using decoder: JSONDecoder) throws -> Value

}

class HTTPResponse: HTTPResponseType {

  let data: Data

  required init(data: Data) {
    self.data = data
  }

  func json<Value: Decodable>(type: Value.Type, using decoder: JSONDecoder = .init()) throws -> Value {
    return try decoder.decode(Value.self, from: data)
  }

}
