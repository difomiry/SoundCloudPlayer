
protocol ServiceProviderType {
  var soundCloudService: SoundCloudServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  private(set) lazy var soundCloudService: SoundCloudServiceType = SoundCloudService(provider: self)
}
