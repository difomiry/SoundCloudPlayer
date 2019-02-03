
protocol ServiceLocatorType {
  var httpClient: HTTPClientType { get }
  var networkService: NetworkServiceType { get }
  var soundCloudService: SoundCloudServiceType { get }
}

final class ServiceLocator: ServiceLocatorType {

  static let shared = ServiceLocator()

  private(set) lazy var httpClient: HTTPClientType = HTTPClient()
  private(set) lazy var networkService: NetworkServiceType = NetworkService(httpClient: httpClient)
  private(set) lazy var soundCloudService: SoundCloudServiceType = SoundCloudService(networkService: networkService)

}
