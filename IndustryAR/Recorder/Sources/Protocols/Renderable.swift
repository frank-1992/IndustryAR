//
//  Renderable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation
import UIKit
import Metal

public protocol Renderable {

  func render(atTime time: TimeInterval)

  func render(atTime time: TimeInterval, using commandQueue: MTLCommandQueue)
}

public extension Renderable {

  func render() { render(atTime: CACurrentMediaTime()) }

  func render(using commandQueue: MTLCommandQueue) {
    render(atTime: CACurrentMediaTime(), using: commandQueue)
  }

  func render(atTime time: TimeInterval, using commandQueue: MTLCommandQueue) {
    render(atTime: time)
  }
}
