
protocol ServiceProviderType {
  var httpClient: HTTPClient { get }
  var soundCloudService: SoundCloudServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  private(set) lazy var httpClient = HTTPClient()
  private(set) lazy var soundCloudService: SoundCloudServiceType = SoundCloudService(httpClient: httpClient)
}
