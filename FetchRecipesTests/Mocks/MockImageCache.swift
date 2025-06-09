//
//  MockImageCache.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import UIKit
import XCTest
@testable import FetchRecipes

actor MockImageCache: ImageCacheProtocol {
    private var cache: [String: UIImage] = [:]
    var saveWasCalled = false
    var loadWasCalled = false
    
    func loadImage(from url: URL) async throws -> UIImage? {
        loadWasCalled = true
        return cache[url.absoluteString]
    }
    
    func saveImage(_ image: UIImage, for url: URL) async throws {
        saveWasCalled = true
        cache[url.absoluteString] = image
    }
    
    func clearCache() {
        cache.removeAll()
    }
}
