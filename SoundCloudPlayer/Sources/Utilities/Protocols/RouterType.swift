
protocol RouterType: class {

  associatedtype Route

  func navigate(to route: Route)

}
