
protocol ViewModelType: class {

  associatedtype Input
  associatedtype Output

  func fetchOutput(_ input: Input?) -> Output

}
