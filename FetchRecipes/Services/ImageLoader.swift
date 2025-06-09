//
//  ImageLoader.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI
import Combine

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let url: URL
    private let cache: ImageCacheProtocol
    private var cancellable: AnyCancellable?
    
    init(url: URL, cache: ImageCacheProtocol = ImageCache()) {
        self.url = url
        self.cache = cache
    }
    
    func load() async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            // Check cache first
            if let cachedImage = try await cache.loadImage(from: url) {
                self.image = cachedImage
                self.isLoading = false
                return
            }
            
            // Download image
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let downloadedImage = UIImage(data: data) else {
                throw ImageCacheError.invalidImageData
            }
            
            // Save to cache
            try await cache.saveImage(downloadedImage, for: url)
            
            self.image = downloadedImage
        } catch {
            print("Failed to load image: \(error)")
        }
        
        isLoading = false
    }
}
