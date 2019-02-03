
protocol ViewModelType: class {

  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output

}
