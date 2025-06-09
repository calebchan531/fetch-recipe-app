//
//  RecipeListViewModelTests.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import XCTest
@testable import FetchRecipes

@MainActor
class RecipeListViewModelTests: XCTestCase {
    var sut: RecipeListViewModel!
    var mockService: MockRecipeService!
    
    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        sut = RecipeListViewModel(recipeService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testLoadRecipesSuccess() async {
        // Given
        let testRecipes = [
            createTestRecipe(),
            Recipe(uuid: "2", name: "Recipe 2", cuisine: "Mexican",
                   photoUrlLarge: nil, photoUrlSmall: nil,
                   sourceUrl: nil, youtubeUrl: nil)
        ]
        mockService.recipesToReturn = testRecipes
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertEqual(sut.recipes.count, 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.showEmptyState)
    }
    
    func testLoadRecipesEmpty() async {
        // Given
        mockService.recipesToReturn = []
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertTrue(sut.showEmptyState)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoadRecipesError() async {
        // Given
        mockService.errorToThrow = NetworkError.serverError(500)
        
        // When
        await sut.loadRecipes()
        
        // Then
        XCTAssertTrue(sut.recipes.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testSortingByName() async {
        // Given
        mockService.recipesToReturn = [
            Recipe(uuid: "1", name: "Zebra Cake", cuisine: "American",
                   photoUrlLarge: nil, photoUrlSmall: nil,
                   sourceUrl: nil, youtubeUrl: nil),
            Recipe(uuid: "2", name: "Apple Pie", cuisine: "American",
                   photoUrlLarge: nil, photoUrlSmall: nil,
                   sourceUrl: nil, youtubeUrl: nil)
        ]
        
        // When
        await sut.loadRecipes()
        sut.sortOption = .name
        
        // Then
        XCTAssertEqual(sut.filteredAndSortedRecipes[0].name, "Apple Pie")
        XCTAssertEqual(sut.filteredAndSortedRecipes[1].name, "Zebra Cake")
    }
    
    func testSearchFiltering() async {
        // Given
        mockService.recipesToReturn = [
            Recipe(uuid: "1", name: "Pasta", cuisine: "Italian",
                   photoUrlLarge: nil, photoUrlSmall: nil,
                   sourceUrl: nil, youtubeUrl: nil),
            Recipe(uuid: "2", name: "Tacos", cuisine: "Mexican",
                   photoUrlLarge: nil, photoUrlSmall: nil,
                   sourceUrl: nil, youtubeUrl: nil)
        ]
        
        // When
        await sut.loadRecipes()
        sut.searchText = "pasta"
        
        // Then
        XCTAssertEqual(sut.filteredAndSortedRecipes.count, 1)
        XCTAssertEqual(sut.filteredAndSortedRecipes[0].name, "Pasta")
    }
}
