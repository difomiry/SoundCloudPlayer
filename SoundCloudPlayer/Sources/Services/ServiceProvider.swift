
final class ServiceProvider {

  private(set) lazy var httpClient = HTTPClient<SoundCloudRequest>()
  private(set) lazy var soundCloudService = SoundCloudService(provider: self)

}
