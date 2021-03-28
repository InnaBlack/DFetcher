//
//  File.swift
//  AppExtention
//
//  Created by  inna on 03/03/2021.
//

import Foundation

public typealias DispatcherIdentifier = String

open class ShedulerGCD {
    
    public static let shared: ShedulerGCD = .init()
    
    public var items: [DispatcherIdentifier: DispatchWorkItem] = .init()
    private let queue: DispatchQueue
    private var timer: Timer?
    
    deinit {
        cancelAllActions()
    }
    
    public init(_ queue: DispatchQueue = .main) {
       
        self.queue = queue
    }
        
    public func schedule(
                  with identifier: DispatcherIdentifier,
                  action: @escaping () -> Void) {
        cancelAction(with: identifier)
        
        print("Scheduled work item \(identifier)")
        let item = DispatchWorkItem(block: action)
        items[identifier] = item

    }
    
    @discardableResult
    public func cancelAction(with identifier: DispatcherIdentifier) -> Bool {
        guard let item = items[identifier] else {
            return false
        }
        
        defer {
            items[identifier] = nil
        }
        
        guard !item.isCancelled else {
            return false
        }
        
        item.cancel()
        print("Cancelled \(identifier)")
        
        return true
    }
    
    
    @discardableResult
    public  func pausedAction(with identifier: DispatcherIdentifier) -> Bool {
        guard let item = items[identifier] else {
            return false
        }
        
        item.wait()
        print("Paused \(identifier)")
        
        return true
    }
    
    @discardableResult
    public func startAction(with identifier: DispatcherIdentifier, on queue: DispatchQueue? = nil) -> Bool {
        guard let item = items[identifier] else {
            return false
        }
        (queue ?? self.queue).asyncAfter(deadline: .now(), execute: item)
        
        print("Start \(identifier)")
        
        return true
    }
    
    public func pausedAll() {
        items.keys.forEach {
            items[$0]?.wait()
        }
    }
    
    public func cancelAllActions() {
        items.keys.forEach {
            items[$0]?.cancel()
            items[$0] = nil
        }
    }
    
    public func startAll() {
        items.keys.forEach {
            items[$0]?.perform()
        }
    }
    
}
