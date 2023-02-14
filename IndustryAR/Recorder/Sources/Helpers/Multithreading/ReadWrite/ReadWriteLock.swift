//
//  ReadWriteLock.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation

public final class ReadWriteLock {

  private var readWriteLock: pthread_rwlock_t

  public init() {
    readWriteLock = pthread_rwlock_t()
    pthread_rwlock_init(&readWriteLock, nil)
  }

  deinit { pthread_rwlock_destroy(&readWriteLock) }

  public func readLock() { pthread_rwlock_rdlock(&readWriteLock) }

  public func writeLock() { pthread_rwlock_wrlock(&readWriteLock) }

  public func unlock() { pthread_rwlock_unlock(&readWriteLock) }

  public func tryRead() -> Bool { pthread_rwlock_tryrdlock(&readWriteLock) == 0 }

  public func tryWrite() -> Bool { pthread_rwlock_trywrlock(&readWriteLock) == 0 }
}

public extension ReadWriteLock {

  @discardableResult
  func readLocked<Result>(_ action: () throws -> Result) rethrows -> Result {
    readLock()
    defer { unlock() }
    return try action()
  }

  @discardableResult
  func writeLocked<Result>(_ action: () throws -> Result) rethrows -> Result {
    writeLock()
    defer { unlock() }
    return try action()
  }
}
