//
//  Cacheable.swift
//  SwiftLRU
//
//  Created by admin on 2020/3/19.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

public protocol EmptyValueType {
    
    /// LRU need a empty value to create virtual head & tail node
    static var empty: Self { get }
}

extension Int: EmptyValueType {
    public static var empty: Int {0}
}

extension Int8: EmptyValueType {
    public static var empty: Int8 {0}
}

extension Int16: EmptyValueType {
    public static var empty: Int16 {0}
}

extension Int32: EmptyValueType {
    public static var empty: Int32 {0}
}

extension Int64: EmptyValueType {
    public static var empty: Int64 {0}
}

extension Double: EmptyValueType {
    public static var empty: Double {0}
}

extension Float: EmptyValueType {
    public static var empty: Float {0}
}

extension String: EmptyValueType {
    public static var empty: String {""}
}

extension Array: EmptyValueType {
    public static var empty: Array {[]}
}

extension Dictionary: EmptyValueType {
    public static var empty: Dictionary {[:]}
}



