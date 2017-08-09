//
//  Namespace.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 17/4/12.
//  Copyright © 2017年 Guo Zhiqiang. All rights reserved.
//

import Foundation


public protocol NamespaceWrappable {
    associatedtype WrapperType
    var lp: WrapperType { get }
    static var lp: WrapperType.Type { get }
}

public extension NamespaceWrappable {
    var lp: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    static var lp: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}
