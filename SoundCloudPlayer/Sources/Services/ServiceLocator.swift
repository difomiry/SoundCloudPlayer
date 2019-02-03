
protocol ServiceLocatorType {
  var httpClient: HTTPClient { get }
  var soundCloudService: SoundCloudServiceType { get }
}

final class ServiceLocator: ServiceLocatorType {

  static let shared = ServiceLocator()

  private(set) lazy var httpClient = HTTPClient()
  private(set) lazy var soundCloudService: SoundCloudServiceType = SoundCloudService(httpClient: httpClient)

}
