//
//  RecipeListViewModel.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI
import Combine

enum FilterOption: String, CaseIterable {
    case all = "All Recipes"
    case favorites = "Favorites"
}

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
    @Published var filterOption: FilterOption = .all
    
    private let recipeService: RecipeServiceProtocol
    let favoritesManager: FavoritesManager
    private var cancellables = Set<AnyCancellable>()
    
    var filteredAndSortedRecipes: [Recipe] {
        var filtered = recipes
        
        // Filter by favorites
        if filterOption == .favorites {
            let favoriteIDs = favoritesManager.getFavoriteIDs()
            filtered = filtered.filter { favoriteIDs.contains($0.id) }
        }
        
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
        !isLoading && filteredAndSortedRecipes.isEmpty && errorMessage == nil
    }
    
    var emptyStateMessage: String {
        if filterOption == .favorites && searchText.isEmpty {
            return "No favorite recipes yet.\nTap the heart icon to add favorites!"
        } else if !searchText.isEmpty {
            return "No recipes found for '\(searchText)'"
        } else {
            return "No recipes available"
        }
    }
    
    init(recipeService: RecipeServiceProtocol = RecipeService(),
         favoritesManager: FavoritesManager = FavoritesManager()) {
        self.recipeService = recipeService
        self.favoritesManager = favoritesManager
        
        // Debounce search
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        // Listen to favorites changes
        favoritesManager.$favoriteIDs
            .dropFirst()
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
    
    func toggleFavorite(for recipe: Recipe) {
        favoritesManager.toggleFavorite(recipe.id)
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        favoritesManager.isFavorite(recipe.id)
    }
}
