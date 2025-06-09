//
//  RecipeListViewModel.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI
import Combine

enum SortOption: String, CaseIterable {
    case none = "Default"
    case name = "Name"
    case cuisine = "Cuisine"
}

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var sortOption: SortOption = .none
    @Published var searchText = ""
    
    private let recipeService: RecipeServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var filteredAndSortedRecipes: [Recipe] {
        var filtered = recipes
        
        // Filter by search
        if !searchText.isEmpty {
            filtered = filtered.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.cuisine.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Sort
        switch sortOption {
        case .none:
            return filtered
        case .name:
            return filtered.sorted { $0.name < $1.name }
        case .cuisine:
            return filtered.sorted { $0.cuisine < $1.cuisine }
        }
    }
    
    var showEmptyState: Bool {
        !isLoading && recipes.isEmpty && errorMessage == nil
    }
    
    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
        
        // Debounce search
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func loadRecipes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedRecipes = try await recipeService.fetchRecipes()
            
            if fetchedRecipes.isEmpty {
                self.recipes = []
            } else {
                self.recipes = fetchedRecipes
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.recipes = []
        }
        
        isLoading = false
    }
    
    func refresh() async {
        await loadRecipes()
    }
}
