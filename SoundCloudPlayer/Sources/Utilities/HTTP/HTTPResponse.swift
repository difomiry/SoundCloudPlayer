
import Foundation

protocol HTTPResponseType {

  var data: Data { get }

  init(data: Data)

  func json<ValueType: Decodable>(type: ValueType.Type, using decoder: JSONDecoder) throws -> ValueType

}

class HTTPResponse: HTTPResponseType {

  let data: Data

  required init(data: Data) {
    self.data = data
  }

  func json<Value: Decodable>(type: Value.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> Value {
    return try decoder.decode(Value.self, from: data)
  }

}
