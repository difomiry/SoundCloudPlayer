
class ObservableArray<ObservedType>: Observable<[ObservedType]> {

  var count: Int {
    return value?.count ?? 0
  }

  subscript(index: Int) -> ObservedType? {
    return value?.indices.contains(index) ?? false ? value?[index] : nil
  }

}
