//
//  UnfairLock.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation

public final class UnfairLock {

  let unfairLock: os_unfair_lock_t

  public init() {
    unfairLock = .allocate(capacity: 1)
    unfairLock.initialize(to: os_unfair_lock())
  }

  deinit {
    unfairLock.deinitialize(count: 1)
    unfairLock.deallocate()
  }

  public func `try`() -> Bool { os_unfair_lock_trylock(unfairLock) }

  public func lock() { os_unfair_lock_lock(unfairLock) }

  public func unlock() { os_unfair_lock_unlock(unfairLock) }
}

public extension UnfairLock {

  @discardableResult
  func locked<Result>(_ action: () throws -> Result) rethrows -> Result {
    lock()
    defer { unlock() }
    return try action()
  }
}
