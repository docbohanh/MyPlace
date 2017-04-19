//
//  RxRealm extensions
//
//  Copyright (c) 2016 RxSwiftCommunity. All rights reserved.
//

import Foundation
import RealmSwift

/**
 `NotificationEmitter` is a protocol to allow for Realm's collections to be handled in a generic way.
 
  All collections already include a `addNotificationBlock(_:)` method - making them conform to `NotificationEmitter` just makes it easier to add Rx methods to them.
 
  The methods of essence in this protocol are `asObservable(...)`, which allow for observing for changes on Realm's collections.
*/
public protocol NotificationEmitter {

    associatedtype ElementType

    /**
     Returns a `NotificationToken`, which while retained enables change notifications for the current collection.
     
     - returns: `NotificationToken` - retain this value to keep notifications being emitted for the current collection.
     */
    func addNotificationBlock(_ block: @escaping (RealmCollectionChange<Self>) -> ()) -> NotificationToken

    func toArray() -> [ElementType]
}

extension List: NotificationEmitter {
    public typealias ElementType = Element
    public func toArray() -> [Element] {
        return Array(self)
    }
}
extension AnyRealmCollection: NotificationEmitter {
    public typealias ElementType = Element
    public func toArray() -> [Element] {
        return Array(self)
    }
}
extension Results: NotificationEmitter {
    public typealias ElementType = Element
    public func toArray() -> [Element] {
        return Array(self)
    }
}
extension LinkingObjects: NotificationEmitter {
    public typealias ElementType = Element
    public func toArray() -> [Element] {
        return Array(self)
    }
}

