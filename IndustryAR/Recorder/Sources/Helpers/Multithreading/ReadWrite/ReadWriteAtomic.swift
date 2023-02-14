//
//  ReadWriteAtomic.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation

@propertyWrapper
public final class ReadWriteAtomic<Value>: Atomic {

  private let lock = ReadWriteLock()

  private var _wrappedValue: Value

  public var wrappedValue: Value {
    get { value }
    set { value = newValue }
  }

  public var projectedValue: ReadWriteAtomic<Value> { self }

  public init(wrappedValue: Value) { self._wrappedValue = wrappedValue }

  @discardableResult
  public func withValue<Result>(_ action: (Value) throws -> Result) rethrows -> Result {
    try lock.readLocked { try action(_wrappedValue) }
  }

  @discardableResult
  public func modify<Result>(_ action: (inout Value) throws -> Result) rethrows -> Result {
    try lock.writeLocked { try action(&_wrappedValue) }
  }
}

extension ReadWriteAtomic: ObservableInterface where Value: ObservableInterface { }
