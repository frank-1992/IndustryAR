//
//  Property.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/6/22.
//
import Foundation

public final class Property<Value> {

  public internal(set) var value: Value { didSet { observer?(value) } }

  public var observer: ((Value) -> Void)?

  init(_ value: Value) { self.value = value }
}
