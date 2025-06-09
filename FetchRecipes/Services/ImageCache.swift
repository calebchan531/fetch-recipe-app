//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import Foundation

import UIKit
import CryptoKit

enum ImageCacheError: LocalizedError {
    case invalidImageData
    case compressionFailed
    case fileOperationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidImageData:
            return "Invalid image data"
        case .compressionFailed:
            return "Failed to compress image"
        case .fileOperationFailed:
            return "File operation failed"
        }
    }
}

protocol ImageCacheProtocol {
    func loadImage(from url: URL) async throws -> UIImage?
    func saveImage(_ image: UIImage, for url: URL) async throws
    func clearCache() async
}

actor ImageCache: ImageCacheProtocol {
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        
        try? fileManager.createDirectory(at: cacheDirectory,
                                       withIntermediateDirectories: true)
        
        // Configure memory cache
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 100 * 1024 * 1024 // 100MB
    }
    
    func loadImage(from url: URL) async throws -> UIImage? {
        let key = cacheKey(for: url)
        
        // Check memory cache
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return cachedImage
        }
        
        // Check disk cache
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            guard let image = UIImage(data: data) else {
                throw ImageCacheError.invalidImageData
            }
            
            // Store in memory cache
            memoryCache.setObject(image, forKey: key as NSString)
            
            return image
        } catch {
            throw ImageCacheError.fileOperationFailed
        }
    }
    
    func saveImage(_ image: UIImage, for url: URL) async throws {
        let key = cacheKey(for: url)
        
        // Save to memory cache
        memoryCache.setObject(image, forKey: key as NSString)
        
        // Save to disk
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw ImageCacheError.compressionFailed
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw ImageCacheError.fileOperationFailed
        }
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory,
                                       withIntermediateDirectories: true)
    }
    
    private func cacheKey(for url: URL) -> String {
        let data = Data(url.absoluteString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
