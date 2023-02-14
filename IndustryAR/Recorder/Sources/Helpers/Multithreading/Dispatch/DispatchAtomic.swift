//
//  DispatchAtomic.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation

@propertyWrapper
public final class DispatchAtomic<Value>: Atomic {

  private var _wrappedValue: Value

  public let queue: DispatchQueue

  public var wrappedValue: Value {
    get { value }
    set { value = newValue }
  }

  public var projectedValue: DispatchAtomic<Value> { self }

  public init(wrappedValue: Value) {
    self._wrappedValue = wrappedValue
    self.queue = DispatchQueue(label: "\(type(of: self))", attributes: [.concurrent])
  }

  public init(wrappedValue: Value, queue: DispatchQueue) {
    self._wrappedValue = wrappedValue
    self.queue = queue
  }

  @discardableResult
  public func withValue<Result>(_ action: (Value) throws -> Result) rethrows -> Result {
    try queue.sync { try action(_wrappedValue) }
  }

  @discardableResult
  public func modify<Result>(_ action: (inout Value) throws -> Result) rethrows -> Result {
    try queue.sync(flags: .barrier) { try action(&_wrappedValue) }
  }

  public func asyncModify(_ action: @escaping (inout Value) -> Void) {
    queue.async(flags: .barrier) { action(&self._wrappedValue) }
  }
}

extension DispatchAtomic: ObservableInterface where Value: ObservableInterface { }
