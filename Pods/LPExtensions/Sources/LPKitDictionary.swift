//
//  LPKitDictionary.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/8.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import Foundation

/// Merge the dictionary
public func += <Key, Value>( left: inout Dictionary<Key, Value>, right: Dictionary<Key, Value>) {
    left.merge(right)
}

public func + <Key, Value> (left: [Key: Value], right: [Key: Value]) -> [Key: Value] {
    var mutableLeft = left
    mutableLeft.merge(right)
    return mutableLeft
}

extension Dictionary {
    
    /// merge a sequence to a dictionary
    public mutating func merge<S>(_ other: S) where S: Sequence, S.Iterator.Element == (key: Key, value: Value) {
        for (k, v) in other {
            self[k] = v
        }
    }
    
    public init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Key, value: Value) {
        self = [:]
        self.merge(sequence)
    }
    
    public func mapValues<NewValue>(transform: (Value) -> NewValue) -> [Key: NewValue] {
        return Dictionary<Key, NewValue>(map({ (key, value) in
            return (key, transform(value))
        }))
    }
  
  func urlEncode(key: Key, value: Value) -> String {
    let keyString = "\(key)"
    let valueString = "\(value)"
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="
    
    var allowedCharacterSet = CharacterSet.urlQueryAllowed
    allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    
    let addKeyString = keyString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? keyString
    let addValueString = valueString.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? valueString
    
    return addKeyString + "=" + addValueString
  }
  
  /// Build the url encoding string with current dictionary
  public func urlEncodedString() -> String {
    var parts: [String] = []
    for ( key, value ) in self {
      let part = urlEncode(key: key, value: value)
      parts.append(part)
    }
    return parts.joined(separator: "&")
  }
  
}
