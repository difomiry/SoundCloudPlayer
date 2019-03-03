
import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayer {

  public func periodicTimeObserver(interval: CMTime) -> Observable<CMTime> {
    return Observable.create { observer in
      let t = self.base.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
        observer.onNext(time)
      }

      return Disposables.create { self.base.removeTimeObserver(t) }
    }
  }

  public func boundaryTimeObserver(times: [CMTime]) -> Observable<Void> {
    return Observable.create { observer in
      let timeValues = times.map() { NSValue(time: $0) }
      let t = self.base.addBoundaryTimeObserver(forTimes: timeValues, queue: nil) {
        observer.onNext(())
      }

      return Disposables.create { self.base.removeTimeObserver(t) }
    }
  }

}
