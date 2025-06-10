//
//  FavoritesManagerTests.swift
//  FetchRecipesTests
//
//  Created by Caleb Chan on 6/9/25.
//

import XCTest
@testable import FetchRecipes

class FavoritesManagerTests: XCTestCase {
    var sut: FavoritesManager!
    var mockUserDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = UserDefaults(suiteName: "TestDefaults")
        mockUserDefaults.removePersistentDomain(forName: "TestDefaults")
        sut = FavoritesManager(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        mockUserDefaults.removePersistentDomain(forName: "TestDefaults")
        sut = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func testToggleFavoriteAdds() {
        // Given
        let recipeID = "test-123"
        
        // When
        sut.toggleFavorite(recipeID)
        
        // Then
        XCTAssertTrue(sut.isFavorite(recipeID))
        XCTAssertEqual(sut.getFavoriteIDs().count, 1)
    }
    
    func testToggleFavoriteRemoves() {
        // Given
        let recipeID = "test-123"
        sut.toggleFavorite(recipeID) // Add first
        
        // When
        sut.toggleFavorite(recipeID) // Remove
        
        // Then
        XCTAssertFalse(sut.isFavorite(recipeID))
        XCTAssertEqual(sut.getFavoriteIDs().count, 0)
    }
    
    func testPersistence() {
        // Given
        let recipeID = "test-123"
        sut.toggleFavorite(recipeID)
        
        // When - Create new instance with same UserDefaults
        let newManager = FavoritesManager(userDefaults: mockUserDefaults)
        
        // Then
        XCTAssertTrue(newManager.isFavorite(recipeID))
    }
    
    func testClearAllFavorites() {
        // Given
        sut.toggleFavorite("1")
        sut.toggleFavorite("2")
        sut.toggleFavorite("3")
        
        // When
        sut.clearAllFavorites()
        
        // Then
        XCTAssertEqual(sut.getFavoriteIDs().count, 0)
    }
}
