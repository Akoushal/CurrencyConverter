//
//  WeakAssociatedObjectHolder.swift
//  CurrencyConverter
//
//  Created by Koushal, KumarAjitesh on 2019/03/13.
//  Copyright © 2019 Koushal, KumarAjitesh. All rights reserved.
//

import Foundation

private class WeakAssociatedObjectContainer<T: AnyObject> {
    weak var object: T?
    convenience init(object: T?) {
        self.init()
        self.object = object
    }
}

public protocol WeakAssociatedObjectHolder: DefaultAssociatedObjectHolder {
}

public extension WeakAssociatedObjectHolder {
    /**
     Returns an associated object that was stored as weak.
     */
    func getWeakAssociatedObject<T: AnyObject>(key: UnsafeRawPointer) -> T? {
        let container = objc_getAssociatedObject(self, key) as? WeakAssociatedObjectContainer<T>
        return container?.object
    }
    /**
     Stores an associated object as weak.
     */
    func setWeakAssociatedObject<T: AnyObject>(key: UnsafeRawPointer, value: T?) {
        let container = getDefaultAssociatedObject(key: key) { return WeakAssociatedObjectContainer<T>() }
        container.object = value
    }
}
