//
//  AsyncImageCache.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 5/16/21.
//

import Foundation
import SwiftUI

class AsyncImageCache {
    
    // 1 create singleton. Singleton will make sure, there is only one entry point to the AsyncImageCache
    //This will be helpful for us, when we will use multiple Async image inside a List
    static let shared = AsyncImageCache()
    // 2 NSCache instance, in memory cache
    private var cache: NSCache = NSCache<NSString, UIImage>()
    // 3 NSCache is a mutable collection, where we are storing data temporarily in a key-value pair. We know that subscript gives us a shortcut way to access data from a collection.
    subscript(key: String) -> UIImage? {
        get { cache.object(forKey: key as NSString) }
        set(image) { image == nil ? self.cache.removeObject(forKey: (key as NSString)) : self.cache.setObject(image!, forKey: (key as NSString)) }
    }
}
