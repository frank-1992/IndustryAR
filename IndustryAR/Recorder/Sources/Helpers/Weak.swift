//
//  Weak.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/7/22.
//

import Foundation

@propertyWrapper
final class Weak<Object: AnyObject> {

  private weak var _wrappedValue: AnyObject?

  var wrappedValue: Object? {
    get { _wrappedValue as? Object }
    set { _wrappedValue = newValue }
  }

  init(_ object: Object) { self._wrappedValue = object }

  init(wrappedValue: Object?) { self._wrappedValue = wrappedValue }

  func get() -> Object? { wrappedValue }
}
