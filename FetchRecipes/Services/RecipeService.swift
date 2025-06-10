//
//  RecipeService.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe]
}

class RecipeService: RecipeServiceProtocol {
    private let apiClient: APIClientProtocol
    // All Recipes(Working): https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
    // Malformed Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
    // Empty Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let response = try await apiClient.fetch(RecipeResponse.self, from: url)
        return response.recipes
    }
}
