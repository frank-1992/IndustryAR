//
//  WeakCollection.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//

import Foundation

@propertyWrapper
struct WeakCollection<Value: AnyObject> {

  private var _wrappedValue: [Weak<Value>]

  var wrappedValue: [Value] {
    get { _wrappedValue.lazy.compactMap { $0.get() } }
    set { _wrappedValue = newValue.map(Weak.init) }
  }

  init(wrappedValue: [Value]) { self._wrappedValue = wrappedValue.map(Weak.init) }

  mutating func compact() { _wrappedValue = { _wrappedValue }() }
}
