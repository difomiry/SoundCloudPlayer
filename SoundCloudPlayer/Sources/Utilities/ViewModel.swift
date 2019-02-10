
protocol ViewModelType: class {

  associatedtype Input
  associatedtype Output

  func fetchOutput(_ input: Input?) -> Output

}

class ViewModel<Input, Output>: ViewModelType {

  func fetchOutput(_ input: Input?) -> Output {
    fatalError("`fetchOutput` method should be implemented.")
  }

}
