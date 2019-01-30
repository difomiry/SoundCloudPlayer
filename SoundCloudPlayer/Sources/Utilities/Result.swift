
enum Result<Value, Error: Swift.Error> {
  case success(Value)
  case failure(Error)
}
