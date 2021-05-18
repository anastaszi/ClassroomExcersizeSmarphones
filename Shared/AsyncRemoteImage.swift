//
//  AsyncRemoteImage.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 5/16/21.
//
import Foundation
import Combine
import SwiftUI

class AsyncRemoteImage: ObservableObject {
    private var subscription: AnyCancellable?
    // 2
    @Published private(set) var image: UIImage?
    
    //Imagecache singleton
    private var cache = AsyncImageCache.shared
    
    // 3
    func load(url: URL) {
        //Check image in cache
        if let image: UIImage = cache[url.absoluteString] {
                self.image = image
                return
            }
        
        subscription = URLSession.shared
                        .dataTaskPublisher(for: url)      // 1
                        .map { UIImage(data: $0.data) }   // 2 get the UIImage from the data
                        .replaceError(with: nil)          // 3 replace the error with nil
                        .handleEvents(receiveOutput: {    //new add In the receiveOutput event, we will store the image in NSCache.
                            self.cache[url.absoluteString] = $0
                        })
                        .receive(on: DispatchQueue.main)  // 4 receive on the main thread
                        .assign(to: \.image, on: self)    // 5 assign the received value to image property
    }
    // 4
    func cancel() {
        // do something, cancel the subscription when we don’t want to render the image in the UI.
        subscription?.cancel()
    }
    
    deinit {
        subscription?.cancel()
    }
}
