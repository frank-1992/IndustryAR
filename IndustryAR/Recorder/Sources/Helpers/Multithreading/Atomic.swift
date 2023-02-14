//
//  Atomic.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation

public protocol Atomic: AnyObject {

  associatedtype Value

  @discardableResult
  func withValue<Result>(_ action: (Value) throws -> Result) rethrows -> Result

  @discardableResult
  func modify<Result>(_ action: (inout Value) throws -> Result) rethrows -> Result
}

public extension Atomic {

  var value: Value {
    get { withValue { $0 } }
    set { swap(newValue) }
  }

  @discardableResult
  func swap(_ newValue: Value) -> Value {
    modify { (value: inout Value) in
      let oldValue = value
      value = newValue
      return oldValue
    }
  }
}

public extension Atomic where Value: ObservableInterface {

  var observer: Value.Observer? {
    get { value.observer }
    set { value.observer = newValue }
  }
}
