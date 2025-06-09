//
//  ImageCacheTests.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import XCTest
@testable import FetchRecipes

class ImageCacheTests: XCTestCase {
    var sut: ImageCache!
    var testImage: UIImage!
    
    override func setUp() async throws {
        sut = ImageCache()
        testImage = UIImage(systemName: "star.fill")!
        await sut.clearCache()
    }
    
    override func tearDown() async throws {
        await sut.clearCache()
        sut = nil
        testImage = nil
    }
    
    func testSaveAndLoadImage() async throws {
        // Given
        let url = URL(string: "https://example.com/test.jpg")!
        
        // When
        try await sut.saveImage(testImage, for: url)
        let loadedImage = try await sut.loadImage(from: url)
        
        // Then
        XCTAssertNotNil(loadedImage)
    }
    
    func testLoadNonExistentImage() async throws {
        // Given
        let url = URL(string: "https://example.com/nonexistent.jpg")!
        
        // When
        let result = try await sut.loadImage(from: url)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testClearCache() async throws {
        // Given
        let url = URL(string: "https://example.com/test.jpg")!
        try await sut.saveImage(testImage, for: url)
        
        // When
        await sut.clearCache()
        let result = try await sut.loadImage(from: url)
        
        // Then
        XCTAssertNil(result)
    }
    
    func testMemoryCacheHit() async throws {
        // Given
        let url = URL(string: "https://example.com/test.jpg")!
        try await sut.saveImage(testImage, for: url)
        
        // When - Load twice
        let firstLoad = try await sut.loadImage(from: url)
        let secondLoad = try await sut.loadImage(from: url)
        
        // Then - Both should succeed
        XCTAssertNotNil(firstLoad)
        XCTAssertNotNil(secondLoad)
    }
}
