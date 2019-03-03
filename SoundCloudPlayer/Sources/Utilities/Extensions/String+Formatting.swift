
extension String {

  init(milliseconds: Int) {
    self = String(seconds: milliseconds / 1000)
  }

  init(seconds: Int) {
    self = String(format: "%i:%02i", seconds / 60, seconds % 60)
  }

}
