//
//  MockRecipeService.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import Foundation
@testable import FetchRecipes

class MockRecipeService: RecipeServiceProtocol {
    var recipesToReturn: [Recipe] = []
    var errorToThrow: Error?
    
    func fetchRecipes() async throws -> [Recipe] {
        if let error = errorToThrow {
            throw error
        }
        return recipesToReturn
    }
}
