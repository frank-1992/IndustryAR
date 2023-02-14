//
//  Observable.swift
//  SCNRecorder
//
//  Created by 吴熠 on 4/7/22.
//

import Foundation

public protocol ObservableInterface: AnyObject {

  associatedtype Property

  typealias Observer = (Property) -> Void

  var observer: Observer? { get set }
}

@propertyWrapper
public final class Observable<Property>: ObservableInterface {

  public typealias Observer = (Property) -> Void

  public var wrappedValue: Property {
    didSet { observer?(wrappedValue) }
  }

  public var value: Property { wrappedValue }

  public var projectedValue: Observable<Property> { self }

  public var observer: Observer?

  public init(wrappedValue: Property) { self.wrappedValue = wrappedValue }
}

public extension ObservableInterface {

  func observe(
    on queue: DispatchQueue? = nil,
    _ observer: @escaping Observer
  ) {
    // swiftlint:disable opening_brace
    self.observer = queue.map { queue in
      { value in queue.async { observer(value) }}
    } ?? observer
    // swiftlint:enable opening_brace
  }
}

public extension ObservableInterface where Property: Equatable {

  func observeUnique(
    on queue: DispatchQueue? = nil,
    _ observer: @escaping Observer
  ) {
    var oldValue: Property?
    observe(on: queue) { (value) in
      guard oldValue != value else { return }
      observer(value)
      oldValue = value
    }
  }
}
