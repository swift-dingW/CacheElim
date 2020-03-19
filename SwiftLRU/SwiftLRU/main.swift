//
//  main.swift
//  SwiftLRU
//
//  Created by admin on 2020/3/19.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

print("Hello, World!")

let cache = LRUKCache<Int, Int>(maxCapacity: 3)

print(cache.get(1))
cache.put(1, value: 10)
cache.get(1)
cache.put(2, value: 20)
cache.put(2, value: 20)
cache.put(3, value: 30)
print(cache.get(1))
cache.put(4, value: 40)
print(cache.get(2))
