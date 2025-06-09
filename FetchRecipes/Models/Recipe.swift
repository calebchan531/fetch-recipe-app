//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import Foundation

struct Recipe: Codable, Identifiable, Equatable {
    let uuid: String
    let name: String
    let cuisine: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?
    
    var id: String { uuid }
    
    private enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case cuisine
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

