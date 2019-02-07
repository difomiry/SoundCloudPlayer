
protocol ViewModelType: class {

  associatedtype Input
  associatedtype Output

  func transform(_ input: Input) -> Output

}
