//
//  BlockBasedSelector.swift
//  Parking
//
//  Created by Charlton Provatas on 11/9/17.
//  Copyright © 2017 Charlton Provatas. All rights reserved.
//

import Foundation

func Selector(_ block: @escaping () -> Void) -> Selector {
  let selector = NSSelectorFromString("\(CFAbsoluteTimeGetCurrent())")
  class_addMethodWithBlock(_Selector.self, selector) { _ in block() }
  return selector
}

func Selector(_ block: @escaping (Any?) -> Void) -> Selector {
  let selector = NSSelectorFromString("\(CFAbsoluteTimeGetCurrent())")
  class_addMethodWithBlockAndSender(_Selector.self, selector) { (_, sender) in block(sender) }
  return selector
}

let Selector = _Selector.shared

@objc class _Selector: NSObject {
  static let shared = _Selector()
}
