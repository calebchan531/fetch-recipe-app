//
//  RecipeServiceTests.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import XCTest
@testable import FetchRecipes

class RecipeServiceTests: XCTestCase {
    var sut: RecipeService!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        sut = RecipeService(apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        sut = nil
        mockAPIClient = nil
        super.tearDown()
    }
    
    func testFetchRecipesSuccess() async throws {
        // Given
        mockAPIClient.mockData = validRecipeJSON
        
        // When
        let recipes = try await sut.fetchRecipes()
        
        // Then
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0].name, "Test Recipe")
        XCTAssertEqual(recipes[0].cuisine, "Italian")
        XCTAssertEqual(recipes[1].name, "Another Recipe")
    }
    
    func testFetchRecipesEmptyList() async throws {
        // Given
        mockAPIClient.mockData = emptyRecipeJSON
        
        // When
        let recipes = try await sut.fetchRecipes()
        
        // Then
        XCTAssertTrue(recipes.isEmpty)
    }
    
    func testFetchRecipesMalformedData() async {
        // Given
        mockAPIClient.mockData = malformedJSON
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes()
            XCTFail("Should throw decoding error")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testFetchRecipesNetworkError() async {
        // Given
        mockAPIClient.mockError = NetworkError.serverError(500)
        
        // When/Then
        do {
            _ = try await sut.fetchRecipes()
            XCTFail("Should throw network error")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.serverError(500))
        }
    }
}
