//
//  LPKitArray.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/8.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import Foundation

public extension Array {
  
  /// Return an random object from the array
  func randomObject() -> Element? {
    guard self.count > 0 else { return nil }
    
    return self[Int(arc4random()) % self.count]
  }
  
  /// Convert self to JSON as String
  func arrayToJson() -> String? {
    var data: Data
    do {
      data = try JSONSerialization.data(withJSONObject: self, options: .init(rawValue: 0))
    }catch {
      print(error.localizedDescription)
      return nil
    }
    
    let json = String(data: data, encoding: .utf8)
    return json
  }
  
  /// Move an object from an index to another
  mutating func moveObject(from: Int, toIndex to: Int) {
    guard from != to else { return }
    guard from >= 0 && to >= 0 else { return }
    
    let obj = self[from]
    self.remove(at: from)
    
    if to >= self.count {
      self.append(obj)
    }else {
      self.insert(obj, at: to)
    }
  }
}

extension Collection {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Iterator.Element? {
    return index >= startIndex && index < endIndex ? self[index] : nil
  }
}
