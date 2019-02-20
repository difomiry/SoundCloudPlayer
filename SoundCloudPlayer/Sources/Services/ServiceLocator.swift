
import Net

protocol ServiceLocatorType {
  var net: NetType { get }
  var soundCloudService: SoundCloudServiceType { get }
}

final class ServiceLocator: ServiceLocatorType {

  static let shared = ServiceLocator()

  private(set) lazy var net: NetType = Net.default
  private(set) lazy var soundCloudService: SoundCloudServiceType = SoundCloudService(net: net)

}
