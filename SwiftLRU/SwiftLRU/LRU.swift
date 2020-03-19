//
//  LRU.swift
//  SwiftLRU
//
//  Created by admin on 2020/3/19.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class LRUNode<Key: Hashable, Value: EmptyValueType> {
    
    let key:Key
    var value: Value?
    
    init(_ key: Key, _ value: Value?) {
        self.key = key
        self.value = value
    }
    
    var next: LRUNode<Key, Value>?
    var prev: LRUNode<Key, Value>?
}

extension LRUNode: Hashable {
    
    static func == (lhs: LRUNode<Key, Value>, rhs: LRUNode<Key, Value>) -> Bool {
        return lhs.key == rhs.key
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
}


class DoubleLinkedList<Key: Hashable, Value: EmptyValueType> {
    
    var head: LRUNode<Key, Value>?
    var tail: LRUNode<Key, Value>?
    
    private(set) var size: Int = 0
    
    
    func add(_ x: LRUNode<Key, Value>) {
        if self.head == nil {
            self.head = LRUNode(x.key, Value.empty)
            self.head?.next = x
            
            x.prev = self.head
            
            self.tail = LRUNode(x.key, Value.empty)
            x.next = self.tail
            self.tail?.prev = x
        } else {
            x.next = self.head?.next
            x.prev = self.head
            self.head?.next?.prev = x
            self.head?.next = x
        }
        self.size += 1
    }
    
    func remove(_ x: LRUNode<Key, Value>) {
        
        x.prev?.next = x.next
        x.next?.prev = x.prev
        self.size -= 1
    }
    
    func removeLast() -> LRUNode<Key, Value>? {
        
        guard self.size > 0 else { return nil }
        
        let last = self.tail?.prev
        self.remove(last!)
        return last
    }
    
    func count() -> Int { self.size }
}

public final class LRUCache<Key: Hashable, Value: EmptyValueType> {
    
    private var map: [Key : LRUNode<Key, Value>] = [:]
    
    private var cache = DoubleLinkedList<Key, Value>()
    
    public let maxCapacity: Int
    
    public init(maxCapacity: Int) {
        self.maxCapacity = maxCapacity
    }
    
    public func get(_ key: Key) -> Value? {
        guard let node = self.map[key], let value = node.value else {
            return nil
        }
        self.put(key, value: value)
        return value
    }
    
    public func put(_ key: Key, value: Value) {
        let new = LRUNode(key, value)
        
        if let node = self.map[key] {
            self.cache.remove(node)
            self.cache.add(new)
            self.map[key] = new
        } else {
            if self.cache.size == self.maxCapacity, let last = self.cache.removeLast() {
                self.map.removeValue(forKey: last.key)
            }
            self.cache.add(new)
            self.map[key] = new
        }
    }
}

public class LRUKCache<Key: Hashable, Value: EmptyValueType> {
    
    // The times for visited value
    let frequency: Int
    // The max cache size
    let maxCapacity: Int
    
    let LRU: LRUCache<Key, Value>
    
    public init(maxCapacity: Int, frequency: Int = 2) {
        self.maxCapacity = maxCapacity
        self.frequency = frequency
        self.LRU = LRUCache<Key, Value>(maxCapacity: maxCapacity)
    }
    
    var freqMap: [LRUNode<Key, Value>: Int] = [:]
    var keyedMap: [Key : LRUNode<Key, Value>] = [:]
    
    public func get(_ key: Key) -> Value? {
        if let value = self.LRU.get(key) {
            return value
        } else {
            if let node = keyedMap[key], let times = self.freqMap[node] {
                if times + 1 < self.frequency {
                    self.freqMap[node] = times + 1
                } else {
                    self.freqMap.removeValue(forKey: node)
                    self.keyedMap.removeValue(forKey: node.key)
                    self.LRU.put(node.key, value: node.value!)
                }
            }
            return nil
        }
    }
    
    public func put(_ key: Key, value: Value) {
        
        let new = LRUNode(key, value)
        
        if let times = self.freqMap[new] {
            if times + 1 < self.frequency {
                self.freqMap[new] = times + 1
            } else {
                self.freqMap.removeValue(forKey: new)
                self.keyedMap.removeValue(forKey: key)
                self.LRU.put(key, value: value)
            }
        } else {
            self.freqMap[new] = 1
            self.keyedMap[key] = new
        }
    }
}
