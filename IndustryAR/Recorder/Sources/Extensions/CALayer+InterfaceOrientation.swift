//
//  CALayer+Window.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import UIKit

extension CALayer {

  var window: UIWindow? {
    (delegate as? UIView)?.window
      ?? superlayer?.window
      ?? UIApplication.shared.keyWindow
  }

  public var interfaceOrientation: UIInterfaceOrientation {
    if #available(iOS 13.0, *) {
      return window?.windowScene?.interfaceOrientation ?? _interfaceOrientation
    } else {
      return _interfaceOrientation
    }
  }

  private var _interfaceOrientation: UIInterfaceOrientation {
    guard let window = window else { return .unknown }
    let fixedCoordinateSpace = window.screen.fixedCoordinateSpace

    let origin = convert(frame.origin, to: window.layer)
    let fixedOrigin = window.convert(origin, to: fixedCoordinateSpace)

    let isXGreater = fixedOrigin.x > origin.x
    let isYGreater = fixedOrigin.y > origin.y

    switch (isXGreater, isYGreater) {
    case (true, true): return .portraitUpsideDown
    case (true, false): return .landscapeRight
    case (false, true): return .landscapeLeft
    case (false, false): return .portrait
    }
  }
}
