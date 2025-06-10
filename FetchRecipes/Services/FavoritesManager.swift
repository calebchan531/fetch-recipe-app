//
//  FavoritesManager.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
//

import Foundation

protocol FavoritesManagerProtocol {
    func isFavorite(_ recipeID: String) -> Bool
    func toggleFavorite(_ recipeID: String)
    func getFavoriteIDs() -> Set<String>
    func clearAllFavorites()
}

class FavoritesManager: ObservableObject, FavoritesManagerProtocol {
    @Published private(set) var favoriteIDs: Set<String> = []
    
    private let userDefaults: UserDefaults
    private let favoritesKey = "favoriteRecipeIDs"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFavorites()
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            favoriteIDs = decoded
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteIDs) {
            userDefaults.set(encoded, forKey: favoritesKey)
        }
    }
    
    func isFavorite(_ recipeID: String) -> Bool {
        favoriteIDs.contains(recipeID)
    }
    
    func toggleFavorite(_ recipeID: String) {
        if favoriteIDs.contains(recipeID) {
            favoriteIDs.remove(recipeID)
        } else {
            favoriteIDs.insert(recipeID)
        }
        saveFavorites()
    }
    
    func getFavoriteIDs() -> Set<String> {
        favoriteIDs
    }
    
    func clearAllFavorites() {
        favoriteIDs.removeAll()
        saveFavorites()
    }
}
