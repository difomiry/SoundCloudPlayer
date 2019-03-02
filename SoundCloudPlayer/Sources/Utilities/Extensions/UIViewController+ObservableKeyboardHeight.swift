
import UIKit
import RxSwift
import RxCocoa

extension UIViewController {

  var keyboardHeight: Driver<CGFloat> {

    let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .map { notification -> CGFloat in (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }

    let keyboardWillHide = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .map { _ -> CGFloat in 0 }

    return Observable.from([keyboardWillShow, keyboardWillHide]).merge().asDriver(onErrorJustReturn: 0)
  }

}
