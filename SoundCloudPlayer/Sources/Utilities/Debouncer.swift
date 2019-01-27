
class Debouncer {

  private let delay: Double
  private let block: () -> Void

  private weak var timer: Timer?

  init(with delay: Double, for block: @escaping () -> Void) {
    self.delay = delay
    self.block = block
  }

  func call() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(timeInterval: delay, target: Selector, selector: Selector(block), userInfo: nil, repeats: false)
  }

}
