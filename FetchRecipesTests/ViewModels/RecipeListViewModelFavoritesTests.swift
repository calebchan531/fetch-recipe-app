//
//  RecipeListViewModelFavoritesTests.swift
//  FetchRecipesTests
//
//  Created by Caleb Chan on 6/9/25.
//

import XCTest
@testable import FetchRecipes

@MainActor
class RecipeListViewModelFavoritesTests: XCTestCase {
    var sut: RecipeListViewModel!
    var mockService: MockRecipeService!
    var mockFavoritesManager: FavoritesManager!
    
    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        let mockUserDefaults = UserDefaults(suiteName: "TestDefaults")
        mockUserDefaults?.removePersistentDomain(forName: "TestDefaults")
        mockFavoritesManager = FavoritesManager(userDefaults: mockUserDefaults!)
        sut = RecipeListViewModel(recipeService: mockService, favoritesManager: mockFavoritesManager)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        mockFavoritesManager = nil
        super.tearDown()
    }
    
    func testFilterFavorites() async {
        // Given
        let recipes = [
            createTestRecipe(id: "1", name: "Recipe 1"),
            createTestRecipe(id: "2", name: "Recipe 2"),
            createTestRecipe(id: "3", name: "Recipe 3")
        ]
        mockService.recipesToReturn = recipes
        await sut.loadRecipes()
        
        // When - Add some favorites
        sut.toggleFavorite(for: recipes[0])
        sut.toggleFavorite(for: recipes[2])
        sut.filterOption = .favorites
        
        // Then
        XCTAssertEqual(sut.filteredAndSortedRecipes.count, 2)
        XCTAssertTrue(sut.filteredAndSortedRecipes.contains(where: { $0.id == "1" }))
        XCTAssertTrue(sut.filteredAndSortedRecipes.contains(where: { $0.id == "3" }))
    }
    
    func testEmptyFavoritesMessage() async {
        // Given
        mockService.recipesToReturn = [createTestRecipe()]
        await sut.loadRecipes()
        
        // When
        sut.filterOption = .favorites
        
        // Then
        XCTAssertTrue(sut.showEmptyState)
        XCTAssertEqual(sut.emptyStateMessage, "No favorite recipes yet.\nTap the heart icon to add favorites!")
    }
    
    private func createTestRecipe(id: String = "test", name: String = "Test") -> Recipe {
        Recipe(
            uuid: id,
            name: name,
            cuisine: "Italian",
            photoUrlLarge: nil,
            photoUrlSmall: nil,
            sourceUrl: nil,
            youtubeUrl: nil
        )
    }
}
